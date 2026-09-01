param(
    [string]$Organization = "VNG-Realisatie",
    [string]$OutputDirectory = ".\github-pages-rapport",
    [int]$TimeoutSec = 20,
    [int]$LinkTimeoutSec = 15,
    [int]$CodeSearchLimit = 1000,
    [int]$MaxPagesPerSite = 0,
    [int]$MaxConcurrentLinkChecks = 16,
    [switch]$SkipCodeSearch,
    [switch]$SkipContentCheck,
    [switch]$SkipExternalLinks
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
# Invoke-WebRequest in Windows PowerShell 5.1 toont anders veel voortgangsregels
# (en wordt daar merkbaar trager van bij grote HTML-pagina's).
$ProgressPreference = "SilentlyContinue"

$UserAgent = "Mozilla/5.0 (compatible; VNG-GitHubPages-LinkChecker/2.5)"

function Assert-Command {
    param([Parameter(Mandatory = $true)][string]$Name)

    if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) {
        throw "Het commando '$Name' is niet gevonden. Installeer GitHub CLI (gh) en probeer opnieuw."
    }
}

function Invoke-GhJson {
    param(
        [Parameter(Mandatory = $true)][string[]]$Arguments
    )

    $output = & gh @Arguments
    if ($LASTEXITCODE -ne 0) {
        throw "GitHub CLI gaf een fout bij: gh $($Arguments -join ' ')"
    }

    $text = ($output -join "`n").Trim()
    if ([string]::IsNullOrWhiteSpace($text)) {
        return $null
    }

    return ($text | ConvertFrom-Json)
}

function Get-MarkdownTableCells {
    param([Parameter(Mandatory = $true)][string]$Line)

    $trimmed = $Line.Trim()
    if ([string]::IsNullOrWhiteSpace($trimmed) -or -not $trimmed.Contains('|')) {
        return @()
    }

    $trimmed = $trimmed.Trim('|')
    if ([string]::IsNullOrWhiteSpace($trimmed)) {
        return @()
    }

    # Voor deze README-metadata zijn eenvoudige Markdown-tabellen voldoende.
    # Escaped pipes in een cel worden eerst tijdelijk veiliggesteld.
    $placeholder = [char]0xE000
    $safe = $trimmed.Replace('\|', [string]$placeholder)
    $cells = @($safe -split '\|' | ForEach-Object {
        ([string]$_).Replace([string]$placeholder, '|').Trim()
    })

    return $cells
}

function Convert-MarkdownCellToText {
    param([AllowNull()][string]$Value)

    if ([string]::IsNullOrWhiteSpace($Value)) {
        return ""
    }

    $clean = $Value.Trim()
    $clean = $clean -replace '(?i)<br\s*/?>', '; '
    $clean = $clean -replace '\[([^\]]+)\]\([^)]+\)', '$1'
    $clean = $clean -replace '\*\*|__|`', ''
    $clean = $clean -replace '\\([|*_`])', '$1'

    try {
        $clean = [System.Net.WebUtility]::HtmlDecode($clean)
    }
    catch { }

    return $clean.Trim()
}

function Get-OwnerMetadataFromReadmeText {
    param([AllowNull()][string]$ReadmeText)

    $result = [PSCustomObject]@{
        Eigenaar      = ""
        IngevuldDoor  = ""
    }

    if ([string]::IsNullOrWhiteSpace($ReadmeText)) {
        return $result
    }

    $lines = @($ReadmeText -split '\r?\n')

    for ($i = 0; $i -lt $lines.Count; $i++) {
        $headers = @(Get-MarkdownTableCells -Line ([string]$lines[$i]))
        if ($headers.Count -lt 2) {
            continue
        }

        $normalizedHeaders = @($headers | ForEach-Object { ([string]$_).Trim().ToLowerInvariant() })
        $ownerIndex = [Array]::IndexOf($normalizedHeaders, 'eigenaar')
        $filledByIndex = [Array]::IndexOf($normalizedHeaders, 'ingevuld door')

        if ($ownerIndex -lt 0 -or $filledByIndex -lt 0) {
            continue
        }

        for ($j = $i + 1; $j -lt $lines.Count; $j++) {
            $cells = @(Get-MarkdownTableCells -Line ([string]$lines[$j]))
            if ($cells.Count -eq 0) {
                if ($j -gt ($i + 2)) {
                    break
                }
                continue
            }

            # Markdown-scheidingsregel, bijvoorbeeld | --- | --- |
            $separatorCells = @($cells | Where-Object { ([string]$_).Trim() -match '^:?-{3,}:?$' })
            if ($separatorCells.Count -eq $cells.Count) {
                continue
            }

            if ($ownerIndex -lt $cells.Count) {
                $result.Eigenaar = Convert-MarkdownCellToText -Value ([string]$cells[$ownerIndex])
            }
            if ($filledByIndex -lt $cells.Count) {
                $result.IngevuldDoor = Convert-MarkdownCellToText -Value ([string]$cells[$filledByIndex])
            }

            return $result
        }
    }

    return $result
}

function Get-RepositoryReadmeOwnerMetadata {
    param(
        [Parameter(Mandatory = $true)][string]$Organization,
        [Parameter(Mandatory = $true)][string]$Repository
    )

    $empty = [PSCustomObject]@{
        Eigenaar     = ""
        IngevuldDoor = ""
    }

    try {
        # De README API gebruikt automatisch de default branch van de repository.
        $output = & gh api "repos/$Organization/$Repository/readme" 2>$null
        if ($LASTEXITCODE -ne 0) {
            return $empty
        }

        $jsonText = ($output -join "`n").Trim()
        if ([string]::IsNullOrWhiteSpace($jsonText)) {
            return $empty
        }

        $readme = $jsonText | ConvertFrom-Json
        if ($null -eq $readme -or $readme.PSObject.Properties.Name -notcontains 'content') {
            return $empty
        }

        $base64 = ([string]$readme.content) -replace '\s', ''
        if ([string]::IsNullOrWhiteSpace($base64)) {
            return $empty
        }

        $bytes = [System.Convert]::FromBase64String($base64)
        $readmeText = [System.Text.Encoding]::UTF8.GetString($bytes)
        return (Get-OwnerMetadataFromReadmeText -ReadmeText $readmeText)
    }
    catch {
        return $empty
    }
}

function Get-NormalizedUrlKey {
    param([Parameter(Mandatory = $true)][string]$Url)

    return $Url.Trim().TrimEnd('/').ToLowerInvariant()
}

function Remove-UrlFragment {
    param([Parameter(Mandatory = $true)][string]$Url)

    try {
        $builder = New-Object System.UriBuilder([System.Uri]$Url)
        $builder.Fragment = ""
        return $builder.Uri.AbsoluteUri
    }
    catch {
        return $Url
    }
}

function Get-CrawlUrl {
    param([Parameter(Mandatory = $true)][string]$Url)

    try {
        $builder = New-Object System.UriBuilder([System.Uri]$Url)
        $builder.Fragment = ""
        $builder.Query = ""
        return $builder.Uri.AbsoluteUri
    }
    catch {
        return $Url
    }
}

function Get-FinalUrlFromResponse {
    param($Response)

    try {
        if ($null -ne $Response.BaseResponse.RequestMessage.RequestUri) {
            return $Response.BaseResponse.RequestMessage.RequestUri.AbsoluteUri
        }
    }
    catch { }

    try {
        if ($null -ne $Response.BaseResponse.ResponseUri) {
            return $Response.BaseResponse.ResponseUri.AbsoluteUri
        }
    }
    catch { }

    return ""
}

function Get-HttpStatusFromException {
    param($Exception)

    try {
        if ($null -ne $Exception.Response.StatusCode) {
            return [int]$Exception.Response.StatusCode
        }
    }
    catch { }

    return $null
}

function Get-FinalUrlFromException {
    param($Exception)

    try {
        if ($null -ne $Exception.Response.RequestMessage.RequestUri) {
            return $Exception.Response.RequestMessage.RequestUri.AbsoluteUri
        }
    }
    catch { }

    try {
        if ($null -ne $Exception.Response.ResponseUri) {
            return $Exception.Response.ResponseUri.AbsoluteUri
        }
    }
    catch { }

    return ""
}

function Invoke-WebGetDetailed {
    param(
        [Parameter(Mandatory = $true)][string]$Url,
        [int]$TimeoutSec = 20,
        [switch]$IncludeContent
    )

    $statusCode = $null
    $finalUrl = ""
    $result = "Fout"
    $errorMessage = ""
    $content = ""
    $contentType = ""

    try {
        $parameters = @{
            Uri                = $Url
            Method             = "GET"
            MaximumRedirection = 10
            TimeoutSec         = $TimeoutSec
            ErrorAction        = "Stop"
            UserAgent          = $UserAgent
        }

        if ($PSVersionTable.PSVersion.Major -lt 6) {
            $parameters["UseBasicParsing"] = $true
        }

        $response = Invoke-WebRequest @parameters
        $statusCode = [int]$response.StatusCode
        $finalUrl = Get-FinalUrlFromResponse -Response $response

        if ([string]::IsNullOrWhiteSpace($finalUrl)) {
            $finalUrl = $Url
        }

        try {
            $contentType = [string]$response.Headers["Content-Type"]
        }
        catch { }

        if ($IncludeContent) {
            try {
                $content = [string]$response.Content
            }
            catch { }
        }

        $originalKey = Get-NormalizedUrlKey -Url $Url
        $finalKey = Get-NormalizedUrlKey -Url $finalUrl

        if ($statusCode -ge 200 -and $statusCode -lt 300) {
            if ($originalKey -ne $finalKey) {
                $result = "Redirect"
            }
            else {
                $result = "OK"
            }
        }
        elseif ($statusCode -ge 300 -and $statusCode -lt 400) {
            $result = "Redirect"
        }
        else {
            $result = "HTTP-fout"
        }
    }
    catch {
        $statusCode = Get-HttpStatusFromException -Exception $_.Exception
        $finalUrl = Get-FinalUrlFromException -Exception $_.Exception
        $errorMessage = $_.Exception.Message

        if ($null -ne $statusCode) {
            $result = "HTTP-fout"
        }
        elseif ($errorMessage -match '(?i)timed out|timeout|time-out') {
            $result = "Timeout"
        }
        elseif ($errorMessage -match '(?i)name resolution|no such host|remote name could not be resolved|host is unknown|nodename nor servname') {
            $result = "DNS-fout"
        }
        elseif ($errorMessage -match '(?i)SSL|TLS|certificate|trust relationship') {
            $result = "TLS/certificaat-fout"
        }
        elseif ($errorMessage -match '(?i)connection refused|actively refused|could not connect|connection failure') {
            $result = "Verbindingsfout"
        }
        else {
            $result = "Fout"
        }
    }

    [PSCustomObject]@{
        HttpStatus = $statusCode
        FinalUrl   = $finalUrl
        Result     = $result
        Error      = $errorMessage
        Content    = $content
        ContentType = $contentType
    }
}

function Test-WebUrl {
    param(
        [Parameter(Mandatory = $true)][string]$Url,
        [int]$TimeoutSec = 20
    )

    return Invoke-WebGetDetailed -Url $Url -TimeoutSec $TimeoutSec
}

function New-HttpFailureResult {
    param([Parameter(Mandatory = $true)]$Exception)

    $exceptionToInspect = $Exception
    $messages = New-Object System.Collections.Generic.List[string]

    while ($null -ne $exceptionToInspect) {
        if (-not [string]::IsNullOrWhiteSpace([string]$exceptionToInspect.Message)) {
            $messages.Add([string]$exceptionToInspect.Message)
        }
        $exceptionToInspect = $exceptionToInspect.InnerException
    }

    $errorMessage = ($messages.ToArray() -join " | ")
    $result = "Fout"

    if ($Exception -is [System.Threading.Tasks.TaskCanceledException] -or $errorMessage -match '(?i)timed out|timeout|time-out|task was canceled|operation was canceled') {
        $result = "Timeout"
    }
    elseif ($errorMessage -match '(?i)name resolution|no such host|remote name could not be resolved|host is unknown|nodename nor servname|name or service not known') {
        $result = "DNS-fout"
    }
    elseif ($errorMessage -match '(?i)SSL|TLS|certificate|trust relationship') {
        $result = "TLS/certificaat-fout"
    }
    elseif ($errorMessage -match '(?i)connection refused|actively refused|could not connect|connection failure') {
        $result = "Verbindingsfout"
    }

    return [PSCustomObject]@{
        HttpStatus  = $null
        FinalUrl    = ""
        Result      = $result
        Error       = $errorMessage
        Content     = ""
        ContentType = ""
    }
}

function Test-WebUrlsParallel {
    param(
        [Parameter(Mandatory = $true)][string[]]$Urls,
        [int]$TimeoutSec = 15,
        [int]$MaxConcurrency = 16
    )

    $resultMap = @{}
    if ($null -eq $Urls -or $Urls.Count -eq 0) {
        return $resultMap
    }

    if ($MaxConcurrency -lt 1) {
        $MaxConcurrency = 1
    }

    Add-Type -AssemblyName System.Net.Http -ErrorAction Stop

    # Zorg op oudere Windows PowerShell/.NET-combinaties voor TLS 1.2.
    try {
        [System.Net.ServicePointManager]::SecurityProtocol =
            [System.Net.ServicePointManager]::SecurityProtocol -bor [System.Net.SecurityProtocolType]::Tls12
    }
    catch { }

    $handler = [System.Net.Http.HttpClientHandler]::new()
    $handler.AllowAutoRedirect = $true
    $handler.MaxAutomaticRedirections = 10

    if ($null -ne $handler.PSObject.Properties['MaxConnectionsPerServer']) {
        $handler.MaxConnectionsPerServer = $MaxConcurrency
    }

    $client = [System.Net.Http.HttpClient]::new($handler)
    $client.Timeout = [TimeSpan]::FromSeconds($TimeoutSec)
    try {
        $client.DefaultRequestHeaders.UserAgent.ParseAdd($UserAgent)
    }
    catch { }

    $completed = 0
    $total = $Urls.Count

    try {
        for ($offset = 0; $offset -lt $total; $offset += $MaxConcurrency) {
            $batchEnd = [Math]::Min($offset + $MaxConcurrency, $total)
            $pending = New-Object System.Collections.Generic.List[object]

            for ($i = $offset; $i -lt $batchEnd; $i++) {
                $url = [string]$Urls[$i]
                $request = $null

                try {
                    $request = [System.Net.Http.HttpRequestMessage]::new([System.Net.Http.HttpMethod]::Get, [System.Uri]$url)
                    $request.Headers.Accept.ParseAdd('*/*')

                    # ResponseHeadersRead voorkomt dat voor een linkcontrole de hele pagina/PDF wordt gedownload.
                    $task = $client.SendAsync($request, [System.Net.Http.HttpCompletionOption]::ResponseHeadersRead)
                    $pending.Add([PSCustomObject]@{
                        Url     = $url
                        Request = $request
                        Task    = $task
                    })
                }
                catch {
                    if ($null -ne $request) {
                        $request.Dispose()
                    }
                    $resultMap[(Get-NormalizedUrlKey -Url $url)] = New-HttpFailureResult -Exception $_.Exception
                    $completed++
                }
            }

            foreach ($item in $pending.ToArray()) {
                $response = $null
                try {
                    $response = $item.Task.GetAwaiter().GetResult()
                    $statusCode = [int]$response.StatusCode
                    $finalUrl = [string]$response.RequestMessage.RequestUri.AbsoluteUri
                    if ([string]::IsNullOrWhiteSpace($finalUrl)) {
                        $finalUrl = [string]$item.Url
                    }

                    $originalKey = Get-NormalizedUrlKey -Url ([string]$item.Url)
                    $finalKey = Get-NormalizedUrlKey -Url $finalUrl

                    if ($statusCode -ge 200 -and $statusCode -lt 300) {
                        $result = if ($originalKey -ne $finalKey) { 'Redirect' } else { 'OK' }
                    }
                    elseif ($statusCode -ge 300 -and $statusCode -lt 400) {
                        $result = 'Redirect'
                    }
                    else {
                        $result = 'HTTP-fout'
                    }

                    $resultMap[$originalKey] = [PSCustomObject]@{
                        HttpStatus  = $statusCode
                        FinalUrl    = $finalUrl
                        Result      = $result
                        Error       = ""
                        Content     = ""
                        ContentType = ""
                    }
                }
                catch {
                    $resultMap[(Get-NormalizedUrlKey -Url ([string]$item.Url))] = New-HttpFailureResult -Exception $_.Exception
                }
                finally {
                    if ($null -ne $response) {
                        $response.Dispose()
                    }
                    if ($null -ne $item.Request) {
                        $item.Request.Dispose()
                    }
                    $completed++
                }
            }

            if ($completed -eq $total -or ($completed % 100) -lt $MaxConcurrency) {
                Write-Host "  Links getest: $completed / $total"
            }
        }
    }
    finally {
        $client.Dispose()
        $handler.Dispose()
    }

    return $resultMap
}

function Get-LinkAttention {
    param($TestResult)

    if ($null -ne $TestResult.HttpStatus) {
        $status = [int]$TestResult.HttpStatus

        if ($status -eq 404 -or $status -eq 410) {
            return "DEFECT"
        }

        if ($status -eq 401 -or $status -eq 403 -or $status -eq 429) {
            return "CONTROLEREN"
        }

        if ($status -ge 500) {
            return "CONTROLEREN"
        }
    }

    if ($TestResult.Result -eq "OK") {
        return "OK"
    }

    if ($TestResult.Result -eq "Redirect") {
        return "REDIRECT"
    }

    return "CONTROLEREN"
}

function Get-RepositoryNameFromSearchResult {
    param($SearchResult)

    if ($null -eq $SearchResult.repository) {
        return ""
    }

    if ($SearchResult.repository -is [string]) {
        return [string]$SearchResult.repository
    }

    foreach ($propertyName in @("nameWithOwner", "fullName", "name")) {
        try {
            $value = $SearchResult.repository.$propertyName
            if (-not [string]::IsNullOrWhiteSpace([string]$value)) {
                return [string]$value
            }
        }
        catch { }
    }

    return ""
}

function Get-UrlsFromText {
    param(
        [Parameter(Mandatory = $true)][string]$Text,
        [Parameter(Mandatory = $true)][string]$RequiredHostFragment
    )

    $matches = [regex]::Matches($Text, 'https?://[^\s"''<>\)\]\}]+', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)

    $urls = foreach ($match in $matches) {
        $url = $match.Value.TrimEnd('.', ',', ';', ':', '!', '?')
        if ($url -match [regex]::Escape($RequiredHostFragment)) {
            $url
        }
    }

    return @($urls | Sort-Object -Unique)
}

function Get-HtmlTitle {
    param([string]$Html)

    if ([string]::IsNullOrWhiteSpace($Html)) {
        return ""
    }

    $match = [regex]::Match($Html, '(?is)<title\b[^>]*>(?<title>.*?)</title>')
    if (-not $match.Success) {
        return ""
    }

    $title = $match.Groups["title"].Value -replace '(?is)<[^>]+>', ' '
    $title = [System.Net.WebUtility]::HtmlDecode($title)
    $title = ($title -replace '\s+', ' ').Trim()
    return $title
}

function Get-HtmlBaseUrl {
    param(
        [Parameter(Mandatory = $true)][string]$Html,
        [Parameter(Mandatory = $true)][string]$FallbackUrl
    )

    $match = [regex]::Match($Html, '(?is)<base\b[^>]*\bhref\s*=\s*(?:"(?<dq>[^"]*)"|''(?<sq>[^'']*)''|(?<uq>[^\s>]+))')
    if (-not $match.Success) {
        return $FallbackUrl
    }

    $href = ""
    foreach ($groupName in @("dq", "sq", "uq")) {
        if ($match.Groups[$groupName].Success) {
            $href = $match.Groups[$groupName].Value
            break
        }
    }

    if ([string]::IsNullOrWhiteSpace($href)) {
        return $FallbackUrl
    }

    $resolved = Resolve-Href -BaseUrl $FallbackUrl -Href $href
    if ([string]::IsNullOrWhiteSpace($resolved)) {
        return $FallbackUrl
    }

    return $resolved
}

function Get-HyperlinksFromHtml {
    param([Parameter(Mandatory = $true)][string]$Html)

    $results = New-Object System.Collections.Generic.List[object]
    $anchorMatches = [regex]::Matches($Html, '(?is)<a\b(?<attrs>[^>]*)>(?<body>.*?)</a>')

    foreach ($anchorMatch in $anchorMatches) {
        $attrs = $anchorMatch.Groups["attrs"].Value
        $hrefMatch = [regex]::Match($attrs, '(?is)\bhref\s*=\s*(?:"(?<dq>[^"]*)"|''(?<sq>[^'']*)''|(?<uq>[^\s>]+))')

        if (-not $hrefMatch.Success) {
            continue
        }

        $href = ""
        foreach ($groupName in @("dq", "sq", "uq")) {
            if ($hrefMatch.Groups[$groupName].Success) {
                $href = $hrefMatch.Groups[$groupName].Value
                break
            }
        }

        $href = [System.Net.WebUtility]::HtmlDecode($href).Trim()
        if ([string]::IsNullOrWhiteSpace($href)) {
            continue
        }

        $text = $anchorMatch.Groups["body"].Value -replace '(?is)<[^>]+>', ' '
        $text = [System.Net.WebUtility]::HtmlDecode($text)
        $text = ($text -replace '\s+', ' ').Trim()
        if ($text.Length -gt 250) {
            $text = $text.Substring(0, 250)
        }

        $results.Add([PSCustomObject]@{
            Href = $href
            Text = $text
        })
    }

    # PowerShell 5.1 kan een ArgumentException geven bij @($GenericList).
    # ToArray() voorkomt die binder-fout en blijft ook werken in PowerShell 7+.
    return $results.ToArray()
}

function Get-AnchorSetFromHtml {
    param([Parameter(Mandatory = $true)][string]$Html)

    $set = New-Object -TypeName 'System.Collections.Generic.HashSet[string]' -ArgumentList ([System.StringComparer]::Ordinal)

    $idMatches = [regex]::Matches($Html, '(?is)\bid\s*=\s*(?:"(?<dq>[^"]+)"|''(?<sq>[^'']+)''|(?<uq>[^\s>]+))')
    foreach ($match in $idMatches) {
        foreach ($groupName in @("dq", "sq", "uq")) {
            if ($match.Groups[$groupName].Success) {
                $value = [System.Net.WebUtility]::HtmlDecode($match.Groups[$groupName].Value)
                [void]$set.Add($value)
                break
            }
        }
    }

    $nameMatches = [regex]::Matches($Html, '(?is)<a\b[^>]*\bname\s*=\s*(?:"(?<dq>[^"]+)"|''(?<sq>[^'']+)''|(?<uq>[^\s>]+))')
    foreach ($match in $nameMatches) {
        foreach ($groupName in @("dq", "sq", "uq")) {
            if ($match.Groups[$groupName].Success) {
                $value = [System.Net.WebUtility]::HtmlDecode($match.Groups[$groupName].Value)
                [void]$set.Add($value)
                break
            }
        }
    }

    # Voorkom dat PowerShell de HashSet uitpakt tot losse strings.
    # De aanroeper heeft het HashSet-object nodig voor .Contains().
    return ,$set
}

function Resolve-Href {
    param(
        [Parameter(Mandatory = $true)][string]$BaseUrl,
        [Parameter(Mandatory = $true)][string]$Href
    )

    $trimmed = [System.Net.WebUtility]::HtmlDecode($Href).Trim()
    if ([string]::IsNullOrWhiteSpace($trimmed)) {
        return ""
    }

    if ($trimmed -match '^(?i)(mailto|tel|javascript|data|ftp):') {
        return ""
    }

    try {
        $baseUri = [System.Uri]$BaseUrl
        $targetUri = $null
        $ok = [System.Uri]::TryCreate($baseUri, $trimmed, [ref]$targetUri)
        if (-not $ok -or $null -eq $targetUri) {
            return ""
        }

        if ($targetUri.Scheme -notin @("http", "https")) {
            return ""
        }

        return $targetUri.AbsoluteUri
    }
    catch {
        return ""
    }
}

function Test-IsWithinSiteScope {
    param(
        [Parameter(Mandatory = $true)][string]$Url,
        [Parameter(Mandatory = $true)][string]$SiteRoot
    )

    try {
        $target = [System.Uri]$Url
        $root = [System.Uri]$SiteRoot

        if (-not $target.Host.Equals($root.Host, [System.StringComparison]::OrdinalIgnoreCase)) {
            return $false
        }

        $rootPath = $root.AbsolutePath
        if ([string]::IsNullOrWhiteSpace($rootPath)) {
            $rootPath = "/"
        }

        if (-not $rootPath.EndsWith('/')) {
            $lastSlash = $rootPath.LastIndexOf('/')
            if ($lastSlash -ge 0) {
                $rootPath = $rootPath.Substring(0, $lastSlash + 1)
            }
            else {
                $rootPath = "/"
            }
        }

        return $target.AbsolutePath.StartsWith($rootPath, [System.StringComparison]::Ordinal)
    }
    catch {
        return $false
    }
}

function Test-LikelyHtmlUrl {
    param([Parameter(Mandatory = $true)][string]$Url)

    try {
        $uri = [System.Uri]$Url
        $path = $uri.AbsolutePath

        if ($path.EndsWith('/')) {
            return $true
        }

        $extension = [System.IO.Path]::GetExtension($path)
        if ([string]::IsNullOrWhiteSpace($extension)) {
            return $true
        }

        return $extension.ToLowerInvariant() -in @('.html', '.htm', '.xhtml')
    }
    catch {
        return $false
    }
}


function Get-SitemapPageUrls {
    param(
        [Parameter(Mandatory = $true)][string]$SiteRoot,
        [int]$TimeoutSec = 20
    )

    $results = New-Object System.Collections.Generic.List[string]

    $baseForSitemap = $SiteRoot
    if (-not $baseForSitemap.EndsWith('/')) {
        $baseForSitemap += '/'
    }

    $sitemapUrl = Resolve-Href -BaseUrl $baseForSitemap -Href 'sitemap.xml'
    if ([string]::IsNullOrWhiteSpace($sitemapUrl)) {
        return @()
    }

    $response = Invoke-WebGetDetailed -Url $sitemapUrl -TimeoutSec $TimeoutSec -IncludeContent
    if ($response.Result -notin @('OK', 'Redirect') -or [string]::IsNullOrWhiteSpace([string]$response.Content)) {
        return @()
    }

    $locMatches = [regex]::Matches([string]$response.Content, '(?is)<loc\b[^>]*>(?<url>.*?)</loc>')
    foreach ($match in $locMatches) {
        $url = [System.Net.WebUtility]::HtmlDecode($match.Groups['url'].Value).Trim()
        if ([string]::IsNullOrWhiteSpace($url)) {
            continue
        }

        if ((Test-IsWithinSiteScope -Url $url -SiteRoot $SiteRoot) -and (Test-LikelyHtmlUrl -Url $url)) {
            $results.Add((Get-CrawlUrl -Url $url))
        }
    }

    return @($results.ToArray() | Sort-Object -Unique)
}

function Get-NonWebLinkType {
    param([Parameter(Mandatory = $true)][string]$Href)

    if ($Href -match '^(?i)mailto:') { return "E-mail" }
    if ($Href -match '^(?i)tel:') { return "Telefoon" }
    if ($Href -match '^(?i)javascript:') { return "JavaScript" }
    if ($Href -match '^(?i)data:') { return "Data" }
    if ($Href -match '^(?i)ftp:') { return "FTP" }
    return "Niet-web"
}

function Get-FragmentValue {
    param([Parameter(Mandatory = $true)][string]$Url)

    try {
        $fragment = ([System.Uri]$Url).Fragment
        if ([string]::IsNullOrWhiteSpace($fragment)) {
            return ""
        }

        return $fragment.Substring(1)
    }
    catch {
        return ""
    }
}

Assert-Command -Name "gh"

Write-Host "Controle GitHub CLI-authenticatie..." -ForegroundColor Cyan
& gh auth status | Out-Host
if ($LASTEXITCODE -ne 0) {
    throw "Je bent niet ingelogd bij GitHub CLI. Voer eerst 'gh auth login' uit."
}

$resolvedOutputDirectory = [System.IO.Path]::GetFullPath($OutputDirectory)
New-Item -ItemType Directory -Path $resolvedOutputDirectory -Force | Out-Null

$overviewCsv = Join-Path $resolvedOutputDirectory "$Organization-github-pages-overzicht.csv"
$referencesCsv = Join-Path $resolvedOutputDirectory "$Organization-github-pages-verwijzingen.csv"
$pagesCsv = Join-Path $resolvedOutputDirectory "$Organization-paginas.csv"
$linkOccurrencesCsv = Join-Path $resolvedOutputDirectory "$Organization-linkcontrole-alle-voorkomens.csv"
$linkSummaryCsv = Join-Path $resolvedOutputDirectory "$Organization-linkcontrole-samenvatting.csv"

Write-Host "`n1/6 Repositories ophalen van $Organization..." -ForegroundColor Cyan
$repoPages = Invoke-GhJson -Arguments @(
    "api",
    "--paginate",
    "--slurp",
    "orgs/$Organization/repos?per_page=100&type=all"
)

$repositories = @()
foreach ($page in @($repoPages)) {
    foreach ($repo in @($page)) {
        $repositories += $repo
    }
}

if ($repositories.Count -eq 0) {
    throw "Geen repositories gevonden voor organisatie '$Organization'."
}

Write-Host "Gevonden repositories: $($repositories.Count)"

# Alleen openbare, niet-gearchiveerde repositories worden verwerkt.
# Een repository kan zowel 'private' als 'archived' zijn; daarom wordt ook
# het unieke totaal van overgeslagen repositories getoond.
$archivedRepositories = @($repositories | Where-Object { [bool]$_.archived })
$privateRepositories = @($repositories | Where-Object { [bool]$_.private })
$eligibleRepositories = @(
    $repositories | Where-Object {
        (-not [bool]$_.archived) -and (-not [bool]$_.private)
    }
)

$skippedRepositoryCount = $repositories.Count - $eligibleRepositories.Count

Write-Host "  Openbaar en actief: $($eligibleRepositories.Count)" -ForegroundColor Green
Write-Host "  Overgeslagen (uniek): $skippedRepositoryCount" -ForegroundColor DarkYellow
Write-Host "    Gearchiveerd: $($archivedRepositories.Count)" -ForegroundColor DarkYellow
Write-Host "    Private:      $($privateRepositories.Count)" -ForegroundColor DarkYellow

$repoByName = @{}
foreach ($repo in $repositories) {
    $repoByName[$repo.name.ToLowerInvariant()] = $repo
}

# README-metadata wordt alleen voor openbare, actieve repositories
# en per repository maximaal één keer opgehaald.
$repoReadmeMetadata = @{}

$candidateRows = New-Object System.Collections.Generic.List[object]
$referenceRows = New-Object System.Collections.Generic.List[object]
$activeSites = New-Object System.Collections.Generic.List[object]

Write-Host "`n2/6 Actieve GitHub Pages-configuraties ophalen..." -ForegroundColor Cyan
$pagesRepos = @($eligibleRepositories | Where-Object { $_.has_pages -eq $true })
Write-Host "Repositories met has_pages=true: $($pagesRepos.Count)"

foreach ($repo in $pagesRepos) {
    Write-Host "  Pages: $($repo.name)"

    $repoKey = ([string]$repo.name).ToLowerInvariant()
    if (-not $repoReadmeMetadata.ContainsKey($repoKey)) {
        $repoReadmeMetadata[$repoKey] = Get-RepositoryReadmeOwnerMetadata -Organization $Organization -Repository ([string]$repo.name)
    }
    $readmeMetadata = $repoReadmeMetadata[$repoKey]

    try {
        $pages = Invoke-GhJson -Arguments @("api", "repos/$Organization/$($repo.name)/pages")

        if ($null -ne $pages -and -not [string]::IsNullOrWhiteSpace([string]$pages.html_url)) {
            $row = [PSCustomObject]@{
                Url                = [string]$pages.html_url
                Repository         = [string]$repo.name
                Source             = "GitHub Pages API"
                ConfiguredPages    = $true
                PagesStatus        = [string]$pages.status
                BuildType          = [string]$pages.build_type
                SourceBranch       = if ($null -ne $pages.source) { [string]$pages.source.branch } else { "" }
                SourcePath         = if ($null -ne $pages.source) { [string]$pages.source.path } else { "" }
                CustomDomain       = [string]$pages.cname
                Archived           = [bool]$repo.archived
                LastPush           = [string]$repo.pushed_at
                FoundInFile        = ""
                PagesMetadataError = ""
            }
            $candidateRows.Add($row)
            $activeSites.Add([PSCustomObject]@{
                Repository = [string]$repo.name
                Eigenaar   = [string]$readmeMetadata.Eigenaar
                IngevuldDoor = [string]$readmeMetadata.IngevuldDoor
                SiteRoot   = [string]$pages.html_url
                Archived   = [bool]$repo.archived
            })
        }
    }
    catch {
        $candidateRows.Add([PSCustomObject]@{
            Url                = ""
            Repository         = [string]$repo.name
            Source             = "GitHub Pages API"
            ConfiguredPages    = $true
            PagesStatus        = "API-fout"
            BuildType          = ""
            SourceBranch       = ""
            SourcePath         = ""
            CustomDomain       = ""
            Archived           = [bool]$repo.archived
            LastPush           = [string]$repo.pushed_at
            FoundInFile        = ""
            PagesMetadataError = $_.Exception.Message
        })
    }
}

foreach ($repo in $eligibleRepositories) {
    $homepage = [string]$repo.homepage
    if (-not [string]::IsNullOrWhiteSpace($homepage) -and $homepage -match '(?i)\.github\.io(?:/|$)') {
        $candidateRows.Add([PSCustomObject]@{
            Url                = $homepage
            Repository         = [string]$repo.name
            Source             = "Repository homepage"
            ConfiguredPages    = [bool]$repo.has_pages
            PagesStatus        = ""
            BuildType          = ""
            SourceBranch       = ""
            SourcePath         = ""
            CustomDomain       = ""
            Archived           = [bool]$repo.archived
            LastPush           = [string]$repo.pushed_at
            FoundInFile        = ""
            PagesMetadataError = ""
        })
    }
}

if (-not $SkipCodeSearch) {
    Write-Host "`n3/6 Oude/verwijzende Pages-links zoeken in repositorycode..." -ForegroundColor Cyan
    $searchTerm = "$($Organization.ToLowerInvariant()).github.io"

    try {
        $searchResults = Invoke-GhJson -Arguments @(
            "search",
            "code",
            $searchTerm,
            "--owner",
            $Organization,
            "--match",
            "file",
            "--limit",
            [string]$CodeSearchLimit,
            "--json",
            "path,repository,textMatches,url"
        )

        foreach ($item in @($searchResults)) {
            $repositoryName = Get-RepositoryNameFromSearchResult -SearchResult $item
            if ($repositoryName -match '/') {
                $repositoryName = ($repositoryName -split '/', 2)[1]
            }

            $repo = $null
            if (-not [string]::IsNullOrWhiteSpace($repositoryName)) {
                $repoKey = $repositoryName.ToLowerInvariant()
                if ($repoByName.ContainsKey($repoKey)) {
                    $repo = $repoByName[$repoKey]
                }
            }

            # Resultaten uit private of gearchiveerde repositories worden
            # bewust volledig genegeerd. Ook onbekende repositories slaan we
            # over, zodat alleen repositories uit de actuele organisatie-inventaris
            # in de rapportage terechtkomen.
            if ($null -eq $repo -or [bool]$repo.archived -or [bool]$repo.private) {
                continue
            }

            foreach ($textMatch in @($item.textMatches)) {
                $fragment = [string]$textMatch.fragment
                if ([string]::IsNullOrWhiteSpace($fragment)) {
                    continue
                }

                $urls = Get-UrlsFromText -Text $fragment -RequiredHostFragment $searchTerm
                foreach ($url in $urls) {
                    $referenceRows.Add([PSCustomObject]@{
                        Repository = $repositoryName
                        File       = [string]$item.path
                        Url        = $url
                        GitHubUrl  = [string]$item.url
                    })

                    $candidateRows.Add([PSCustomObject]@{
                        Url                = $url
                        Repository         = $repositoryName
                        Source             = "Code-verwijzing"
                        ConfiguredPages    = if ($null -ne $repo) { [bool]$repo.has_pages } else { $false }
                        PagesStatus        = ""
                        BuildType          = ""
                        SourceBranch       = ""
                        SourcePath         = ""
                        CustomDomain       = ""
                        Archived           = if ($null -ne $repo) { [bool]$repo.archived } else { $false }
                        LastPush           = if ($null -ne $repo) { [string]$repo.pushed_at } else { "" }
                        FoundInFile        = [string]$item.path
                        PagesMetadataError = ""
                    })
                }
            }
        }
    }
    catch {
        Write-Warning "Code search kon niet volledig worden uitgevoerd: $($_.Exception.Message)"
    }
}
else {
    Write-Host "`n3/6 Code search overgeslagen (-SkipCodeSearch)." -ForegroundColor DarkYellow
}

if ($referenceRows.Count -gt 0) {
    $referenceRows |
        Sort-Object Repository, File, Url -Unique |
        Export-Csv -Path $referencesCsv -NoTypeInformation -Encoding UTF8
}
else {
    @([PSCustomObject]@{
        Repository = ""
        File       = ""
        Url        = ""
        GitHubUrl  = ""
    }) | Export-Csv -Path $referencesCsv -NoTypeInformation -Encoding UTF8
}

Write-Host "`n4/6 GitHub Pages-hoofd-URL's testen..." -ForegroundColor Cyan

$rowsWithUrl = @($candidateRows | Where-Object { -not [string]::IsNullOrWhiteSpace([string]$_.Url) })
$groups = $rowsWithUrl | Group-Object -Property { Get-NormalizedUrlKey -Url ([string]$_.Url) }
$overviewRows = New-Object System.Collections.Generic.List[object]

foreach ($group in $groups) {
    $items = @($group.Group)
    $preferred = @($items | Where-Object { $_.Source -eq "GitHub Pages API" } | Select-Object -First 1)
    if ($preferred.Count -eq 0) {
        $preferred = @($items | Select-Object -First 1)
    }
    $preferred = $preferred[0]

    Write-Host "  Test: $($preferred.Url)"
    $test = Test-WebUrl -Url ([string]$preferred.Url) -TimeoutSec $TimeoutSec

    $configuredItem = @($items | Where-Object { $_.Source -eq "GitHub Pages API" } | Select-Object -First 1)
    if ($configuredItem.Count -gt 0) {
        $configuredItem = $configuredItem[0]
    }
    else {
        $configuredItem = $null
    }

    $repositoriesForUrl = @($items.Repository | Where-Object { -not [string]::IsNullOrWhiteSpace([string]$_) } | Sort-Object -Unique)
    $sourcesForUrl = @($items.Source | Sort-Object -Unique)
    $filesForUrl = @($items.FoundInFile | Where-Object { -not [string]::IsNullOrWhiteSpace([string]$_) } | Sort-Object -Unique)
    $archivedRepos = @($items | Where-Object { $_.Archived -eq $true } | ForEach-Object { $_.Repository } | Where-Object { $_ } | Sort-Object -Unique)

    $latestPush = @(
        $items.LastPush |
            Where-Object { -not [string]::IsNullOrWhiteSpace([string]$_) } |
            Sort-Object -Descending |
            Select-Object -First 1
    )

    $configuredPages = @($items | Where-Object { $_.ConfiguredPages -eq $true }).Count -gt 0

    $attention = ""
    if ($test.Result -notin @("OK", "Redirect")) {
        $attention = "CONTROLEREN"
    }
    elseif ($archivedRepos.Count -gt 0) {
        $attention = "ARCHIEF"
    }
    elseif (-not $configuredPages -and ($sourcesForUrl -contains "Code-verwijzing")) {
        $attention = "MOGELIJK OUD"
    }
    elseif ($test.Result -eq "Redirect") {
        $attention = "REDIRECT"
    }
    else {
        $attention = "OK"
    }

    $overviewRows.Add([PSCustomObject]@{
        Url                 = [string]$preferred.Url
        FinalUrl            = [string]$test.FinalUrl
        HttpStatus          = $test.HttpStatus
        Resultaat           = [string]$test.Result
        Aandacht            = $attention
        ConfiguredPages     = $configuredPages
        PagesStatus         = if ($null -ne $configuredItem) { [string]$configuredItem.PagesStatus } else { "" }
        BuildType           = if ($null -ne $configuredItem) { [string]$configuredItem.BuildType } else { "" }
        CustomDomain        = if ($null -ne $configuredItem) { [string]$configuredItem.CustomDomain } else { "" }
        SourceBranch        = if ($null -ne $configuredItem) { [string]$configuredItem.SourceBranch } else { "" }
        SourcePath          = if ($null -ne $configuredItem) { [string]$configuredItem.SourcePath } else { "" }
        Repositories        = ($repositoriesForUrl -join "; ")
        Bronnen             = ($sourcesForUrl -join "; ")
        GevondenInBestanden = ($filesForUrl -join "; ")
        GearchiveerdeRepos  = ($archivedRepos -join "; ")
        LaatstePush         = if ($latestPush.Count -gt 0) { [string]$latestPush[0] } else { "" }
        Foutmelding         = [string]$test.Error
        GecontroleerdOp     = (Get-Date).ToString("s")
    })
}

$metadataErrorRows = @($candidateRows | Where-Object {
    [string]::IsNullOrWhiteSpace([string]$_.Url) -and
    -not [string]::IsNullOrWhiteSpace([string]$_.PagesMetadataError)
})

foreach ($item in $metadataErrorRows) {
    $overviewRows.Add([PSCustomObject]@{
        Url                 = ""
        FinalUrl            = ""
        HttpStatus          = $null
        Resultaat           = "Pages API-fout"
        Aandacht            = "CONTROLEREN"
        ConfiguredPages     = $true
        PagesStatus         = [string]$item.PagesStatus
        BuildType           = ""
        CustomDomain        = ""
        SourceBranch        = ""
        SourcePath          = ""
        Repositories        = [string]$item.Repository
        Bronnen             = "GitHub Pages API"
        GevondenInBestanden = ""
        GearchiveerdeRepos  = if ($item.Archived) { [string]$item.Repository } else { "" }
        LaatstePush         = [string]$item.LastPush
        Foutmelding         = [string]$item.PagesMetadataError
        GecontroleerdOp     = (Get-Date).ToString("s")
    })
}

$overviewRows |
    Sort-Object @{ Expression = {
        switch ($_.Aandacht) {
            "CONTROLEREN" { 1 }
            "MOGELIJK OUD" { 2 }
            "ARCHIEF" { 3 }
            "REDIRECT" { 4 }
            default { 5 }
        }
    } }, Url |
    Export-Csv -Path $overviewCsv -NoTypeInformation -Encoding UTF8

$pageRows = New-Object System.Collections.Generic.List[object]
$linkRows = New-Object System.Collections.Generic.List[object]
$anchorMap = @{}
# Compacte cache van pagina-controles. Hiermee hoeven interne pagina-URL's in stap 6 niet opnieuw opgehaald te worden.
$pageTestCache = @{}

if (-not $SkipContentCheck) {
    Write-Host "`n5/6 Alle bereikbare pagina's crawlen en hyperlinks verzamelen..." -ForegroundColor Cyan
    Write-Host "     Dit kan enige tijd duren. Interne HTML-pagina's worden recursief doorlopen." -ForegroundColor DarkGray

    foreach ($site in $activeSites) {
        $siteRoot = [string]$site.SiteRoot
        $repositoryName = [string]$site.Repository
        $repositoryOwner = [string]$site.Eigenaar
        $repositoryFilledBy = [string]$site.IngevuldDoor
        Write-Host "`n  Site: $repositoryName - $siteRoot" -ForegroundColor Yellow

        $queue = New-Object System.Collections.Queue
        $seenPages = @{}
        # Houd ook bij welke URL's al in de wachtrij hebben gestaan. Daardoor kan dezelfde
        # interne pagina niet honderden keren via verschillende bronpagina's worden ingepland.
        $knownPages = @{}

        $rootCrawlUrl = Get-CrawlUrl -Url $siteRoot
        $rootCrawlKey = $rootCrawlUrl.ToLowerInvariant()
        $queue.Enqueue([PSCustomObject]@{
            Url       = $rootCrawlUrl
            Depth     = 0
            FoundFrom = "START"
        })
        $knownPages[$rootCrawlKey] = $true

        $sitemapUrls = @(Get-SitemapPageUrls -SiteRoot $siteRoot -TimeoutSec $TimeoutSec)
        if ($sitemapUrls.Count -gt 0) {
            $addedFromSitemap = 0
            foreach ($sitemapPageUrl in $sitemapUrls) {
                $sitemapCrawlUrl = Get-CrawlUrl -Url ([string]$sitemapPageUrl)
                $sitemapCrawlKey = $sitemapCrawlUrl.ToLowerInvariant()
                if (-not $knownPages.ContainsKey($sitemapCrawlKey)) {
                    $queue.Enqueue([PSCustomObject]@{
                        Url       = $sitemapCrawlUrl
                        Depth     = 0
                        FoundFrom = "SITEMAP.XML"
                    })
                    $knownPages[$sitemapCrawlKey] = $true
                    $addedFromSitemap++
                }
            }
            Write-Host "    Sitemap gevonden: $addedFromSitemap unieke pagina-URL's toegevoegd." -ForegroundColor DarkGray
        }

        $processedCount = 0
        $limitReached = $false

        while ($queue.Count -gt 0) {
            if ($MaxPagesPerSite -gt 0 -and $processedCount -ge $MaxPagesPerSite) {
                $limitReached = $true
                break
            }

            $queueItem = $queue.Dequeue()
            $pageUrl = [string]$queueItem.Url
            $pageKey = (Get-CrawlUrl -Url $pageUrl).ToLowerInvariant()

            if ($seenPages.ContainsKey($pageKey)) {
                continue
            }

            $seenPages[$pageKey] = $true
            $processedCount++

            if ($processedCount -eq 1 -or ($processedCount % 25) -eq 0) {
                Write-Host "    Verwerkt: $processedCount pagina's; nog in wachtrij: $($queue.Count)"
            }

            $pageTest = Invoke-WebGetDetailed -Url $pageUrl -TimeoutSec $TimeoutSec -IncludeContent

            # Sla alleen de compacte testinformatie op, niet de HTML-content zelf.
            $compactPageTest = [PSCustomObject]@{
                HttpStatus  = $pageTest.HttpStatus
                FinalUrl    = [string]$pageTest.FinalUrl
                Result      = [string]$pageTest.Result
                Error       = [string]$pageTest.Error
                Content     = ""
                ContentType = [string]$pageTest.ContentType
            }
            $pageCheckUrl = Remove-UrlFragment -Url $pageUrl
            $pageTestCache[(Get-NormalizedUrlKey -Url $pageCheckUrl)] = $compactPageTest
            if (-not [string]::IsNullOrWhiteSpace([string]$pageTest.FinalUrl)) {
                $finalPageCheckUrl = Remove-UrlFragment -Url ([string]$pageTest.FinalUrl)
                $pageTestCache[(Get-NormalizedUrlKey -Url $finalPageCheckUrl)] = $compactPageTest
            }

            $pageAttention = Get-LinkAttention -TestResult $pageTest
            $title = ""
            $linkCount = 0

            $isHtml = $false
            if (-not [string]::IsNullOrWhiteSpace([string]$pageTest.ContentType)) {
                $isHtml = ([string]$pageTest.ContentType -match '(?i)text/html|application/xhtml\+xml')
            }
            elseif (-not [string]::IsNullOrWhiteSpace([string]$pageTest.Content)) {
                $isHtml = ([string]$pageTest.Content -match '(?is)<html\b|<!doctype\s+html')
            }

            if ($pageTest.Result -in @("OK", "Redirect") -and $isHtml) {
                $title = Get-HtmlTitle -Html ([string]$pageTest.Content)
                $htmlBaseUrl = if (-not [string]::IsNullOrWhiteSpace([string]$pageTest.FinalUrl)) { [string]$pageTest.FinalUrl } else { $pageUrl }
                $htmlBaseUrl = Get-HtmlBaseUrl -Html ([string]$pageTest.Content) -FallbackUrl $htmlBaseUrl

                $anchorSet = Get-AnchorSetFromHtml -Html ([string]$pageTest.Content)
                $requestedAnchorKey = (Get-CrawlUrl -Url $pageUrl).ToLowerInvariant()
                $anchorMap[$requestedAnchorKey] = $anchorSet

                if (-not [string]::IsNullOrWhiteSpace([string]$pageTest.FinalUrl)) {
                    $finalAnchorKey = (Get-CrawlUrl -Url ([string]$pageTest.FinalUrl)).ToLowerInvariant()
                    $anchorMap[$finalAnchorKey] = $anchorSet
                }

                $links = @(Get-HyperlinksFromHtml -Html ([string]$pageTest.Content))
                $linkCount = $links.Count

                foreach ($link in $links) {
                    $rawHref = [string]$link.Href
                    $linkText = [string]$link.Text

                    $resolvedUrl = Resolve-Href -BaseUrl $htmlBaseUrl -Href $rawHref
                    if ([string]::IsNullOrWhiteSpace($resolvedUrl)) {
                        $linkRows.Add([PSCustomObject]@{
                            Repository    = $repositoryName
                            Eigenaar      = $repositoryOwner
                            IngevuldDoor  = $repositoryFilledBy
                            SiteRoot      = $siteRoot
                            Bronpagina    = $pageUrl
                            Linktekst     = $linkText
                            OrigineleHref = $rawHref
                            LinkUrl       = ""
                            CheckUrl      = ""
                            LinkType      = Get-NonWebLinkType -Href $rawHref
                            HttpStatus    = $null
                            Resultaat     = "OVERGESLAGEN"
                            Aandacht      = ""
                            FinalUrl      = ""
                            Anchor        = ""
                            AnchorResultaat = ""
                            Foutmelding   = ""
                        })
                        continue
                    }

                    $isInternal = Test-IsWithinSiteScope -Url $resolvedUrl -SiteRoot $siteRoot
                    $linkType = if ($isInternal) { "Intern" } else { "Extern" }
                    $checkUrl = Remove-UrlFragment -Url $resolvedUrl
                    $fragmentValue = Get-FragmentValue -Url $resolvedUrl

                    $linkRows.Add([PSCustomObject]@{
                        Repository      = $repositoryName
                        Eigenaar        = $repositoryOwner
                        IngevuldDoor    = $repositoryFilledBy
                        SiteRoot        = $siteRoot
                        Bronpagina      = $pageUrl
                        Linktekst       = $linkText
                        OrigineleHref   = $rawHref
                        LinkUrl         = $resolvedUrl
                        CheckUrl        = $checkUrl
                        LinkType        = $linkType
                        HttpStatus      = $null
                        Resultaat       = "NOG TE TESTEN"
                        Aandacht        = ""
                        FinalUrl        = ""
                        Anchor          = $fragmentValue
                        AnchorResultaat = ""
                        Foutmelding     = ""
                    })

                    if ($isInternal -and (Test-LikelyHtmlUrl -Url $resolvedUrl)) {
                        $crawlTarget = Get-CrawlUrl -Url $resolvedUrl
                        $crawlKey = $crawlTarget.ToLowerInvariant()
                        if (-not $knownPages.ContainsKey($crawlKey)) {
                            $queue.Enqueue([PSCustomObject]@{
                                Url       = $crawlTarget
                                Depth     = ([int]$queueItem.Depth + 1)
                                FoundFrom = $pageUrl
                            })
                            $knownPages[$crawlKey] = $true
                        }
                    }
                }
            }

            $pageRows.Add([PSCustomObject]@{
                Repository  = $repositoryName
                Eigenaar    = $repositoryOwner
                IngevuldDoor = $repositoryFilledBy
                SiteRoot    = $siteRoot
                PaginaUrl   = $pageUrl
                FinalUrl    = [string]$pageTest.FinalUrl
                HttpStatus  = $pageTest.HttpStatus
                Resultaat   = [string]$pageTest.Result
                Aandacht    = $pageAttention
                ContentType = [string]$pageTest.ContentType
                Titel       = $title
                AantalLinks = $linkCount
                Diepte      = [int]$queueItem.Depth
                GevondenVia = [string]$queueItem.FoundFrom
                Foutmelding = [string]$pageTest.Error
            })
        }

        if ($limitReached) {
            Write-Host "    BEPERKTE TEST: MaxPagesPerSite=$MaxPagesPerSite bereikt voor $repositoryName. Niet alle bereikbare pagina's zijn verwerkt." -ForegroundColor Yellow
        }
        else {
            Write-Host "    Klaar voor ${repositoryName}: $processedCount pagina's verwerkt." -ForegroundColor Green
        }
    }

    Write-Host "`n6/6 Unieke gevonden hyperlinks testen..." -ForegroundColor Cyan

    $httpLinkRows = @($linkRows | Where-Object {
        -not [string]::IsNullOrWhiteSpace([string]$_.CheckUrl) -and
        ($_.LinkType -eq "Intern" -or (-not $SkipExternalLinks -and $_.LinkType -eq "Extern"))
    })

    # Begin met resultaten die tijdens de crawl al zijn vastgesteld. Interne HTML-pagina's
    # hoeven daardoor niet opnieuw via HTTP getest te worden.
    $testCache = @{}
    foreach ($cacheKey in $pageTestCache.Keys) {
        $testCache[$cacheKey] = $pageTestCache[$cacheKey]
    }

    $uniqueCheckUrls = @($httpLinkRows.CheckUrl | Sort-Object -Unique)
    $totalUnique = $uniqueCheckUrls.Count
    $urlsToTest = New-Object System.Collections.Generic.List[string]
    $reusedCount = 0

    foreach ($checkUrl in $uniqueCheckUrls) {
        $cacheKey = Get-NormalizedUrlKey -Url ([string]$checkUrl)
        if ($testCache.ContainsKey($cacheKey)) {
            $reusedCount++
        }
        else {
            $urlsToTest.Add([string]$checkUrl)
        }
    }

    Write-Host "  Unieke links:                    $totalUnique"
    Write-Host "  Hergebruikt uit pagina-crawl:    $reusedCount"
    Write-Host "  Nog via HTTP te controleren:     $($urlsToTest.Count)"
    Write-Host "  Gelijktijdige controles:         $MaxConcurrentLinkChecks" -ForegroundColor DarkGray

    if ($urlsToTest.Count -gt 0) {
        $parallelResults = Test-WebUrlsParallel -Urls $urlsToTest.ToArray() -TimeoutSec $LinkTimeoutSec -MaxConcurrency $MaxConcurrentLinkChecks
        foreach ($cacheKey in $parallelResults.Keys) {
            $testCache[$cacheKey] = $parallelResults[$cacheKey]
        }
    }

    foreach ($row in $linkRows) {
        if ([string]::IsNullOrWhiteSpace([string]$row.CheckUrl)) {
            continue
        }

        if ($row.LinkType -eq "Extern" -and $SkipExternalLinks) {
            $row.Resultaat = "OVERGESLAGEN"
            $row.Aandacht = ""
            continue
        }

        $cacheKey = Get-NormalizedUrlKey -Url ([string]$row.CheckUrl)
        if (-not $testCache.ContainsKey($cacheKey)) {
            continue
        }

        $test = $testCache[$cacheKey]
        $row.HttpStatus = $test.HttpStatus
        $row.Resultaat = [string]$test.Result
        $row.Aandacht = Get-LinkAttention -TestResult $test
        $row.FinalUrl = [string]$test.FinalUrl
        $row.Foutmelding = [string]$test.Error

        if ($row.LinkType -eq "Intern" -and -not [string]::IsNullOrWhiteSpace([string]$row.Anchor)) {
            $anchorValue = [string]$row.Anchor

            if ($anchorValue.StartsWith(':~:text=')) {
                $row.AnchorResultaat = "NIET GECONTROLEERD"
            }
            else {
                try {
                    $decodedAnchor = [System.Uri]::UnescapeDataString($anchorValue)
                }
                catch {
                    $decodedAnchor = $anchorValue
                }

                $anchorTargetKey = (Get-CrawlUrl -Url ([string]$row.CheckUrl)).ToLowerInvariant()
                if ($anchorMap.ContainsKey($anchorTargetKey)) {
                    $set = $anchorMap[$anchorTargetKey]
                    if ($set.Contains($decodedAnchor)) {
                        $row.AnchorResultaat = "OK"
                    }
                    else {
                        $row.AnchorResultaat = "ONTBREEKT"
                        $row.Aandacht = "DEFECT"
                    }
                }
                else {
                    $row.AnchorResultaat = "NIET GECONTROLEERD"
                }
            }
        }
    }

    $pageRows |
        Sort-Object Repository, PaginaUrl |
        Export-Csv -Path $pagesCsv -NoTypeInformation -Encoding UTF8

    # Beheerbestand met iedere gevonden web-URL op de plek waar die voorkomt.
    # De kolomvolgorde is bewust compact gehouden voor verwerking in Excel.
    $checkedAt = (Get-Date).ToString("s")
    $linkRows |
        Where-Object { -not [string]::IsNullOrWhiteSpace([string]$_.LinkUrl) } |
        Sort-Object Repository, Bronpagina, LinkUrl |
        ForEach-Object {
            [PSCustomObject][ordered]@{
                Repository       = [string]$_.Repository
                Eigenaar         = [string]$_.Eigenaar
                'Ingevuld door'  = [string]$_.IngevuldDoor
                Bronpagina       = [string]$_.Bronpagina
                'Gevonden URL'   = [string]$_.LinkUrl
                HttpStatus       = $_.HttpStatus
                'Gecontroleerd op' = $checkedAt
            }
        } |
        Export-Csv -Path $linkOccurrencesCsv -NoTypeInformation -Encoding UTF8

    $summaryRows = New-Object System.Collections.Generic.List[object]
    $summarySourceRows = @($linkRows | Where-Object { -not [string]::IsNullOrWhiteSpace([string]$_.LinkUrl) })
    $summaryGroups = $summarySourceRows | Group-Object -Property { ([string]$_.LinkUrl).ToLowerInvariant() }

    foreach ($group in $summaryGroups) {
        $items = @($group.Group)
        $first = $items[0]
        $sourcePages = @($items.Bronpagina | Sort-Object -Unique)
        $repos = @($items.Repository | Sort-Object -Unique)
        $attentionValues = @($items.Aandacht | Where-Object { -not [string]::IsNullOrWhiteSpace([string]$_) })

        $summaryAttention = ""
        if ($attentionValues -contains "DEFECT") {
            $summaryAttention = "DEFECT"
        }
        elseif ($attentionValues -contains "CONTROLEREN") {
            $summaryAttention = "CONTROLEREN"
        }
        elseif ($attentionValues -contains "REDIRECT") {
            $summaryAttention = "REDIRECT"
        }
        elseif ($attentionValues -contains "OK") {
            $summaryAttention = "OK"
        }

        $anchorResults = @($items.AnchorResultaat | Where-Object { -not [string]::IsNullOrWhiteSpace([string]$_) } | Sort-Object -Unique)

        $summaryRows.Add([PSCustomObject]@{
            Url                 = [string]$first.LinkUrl
            LinkType            = [string]$first.LinkType
            HttpStatus          = $first.HttpStatus
            Resultaat           = [string]$first.Resultaat
            Aandacht            = $summaryAttention
            FinalUrl            = [string]$first.FinalUrl
            AnchorResultaat     = ($anchorResults -join "; ")
            AantalVoorkomens    = $items.Count
            AantalBronpaginas   = $sourcePages.Count
            Repositories        = ($repos -join "; ")
            Bronpaginas         = ($sourcePages -join "; ")
            Foutmelding         = [string]$first.Foutmelding
            GecontroleerdOp     = $checkedAt
        })
    }

    $summaryRows |
        Sort-Object @{ Expression = {
            switch ($_.Aandacht) {
                "DEFECT" { 1 }
                "CONTROLEREN" { 2 }
                "REDIRECT" { 3 }
                "OK" { 4 }
                default { 5 }
            }
        } }, Url |
        Export-Csv -Path $linkSummaryCsv -NoTypeInformation -Encoding UTF8
}
else {
    Write-Host "`n5/6 Content- en linkcontrole overgeslagen (-SkipContentCheck)." -ForegroundColor DarkYellow
    Write-Host "6/6 Geen hyperlinkcontrole nodig." -ForegroundColor DarkYellow
}

$counts = $overviewRows | Group-Object Aandacht | Sort-Object Name

Write-Host "`nKlaar." -ForegroundColor Green
Write-Host "Pages-overzicht:       $overviewCsv"
Write-Host "Code-verwijzingen:     $referencesCsv"

if (-not $SkipContentCheck) {
    Write-Host "Gecrawlde pagina's:     $pagesCsv"
    Write-Host "Alle linkvoorkomens:    $linkOccurrencesCsv"
    Write-Host "Link-samenvatting:      $linkSummaryCsv"
}

Write-Host ""
Write-Host "Samenvatting GitHub Pages:" -ForegroundColor Cyan
foreach ($count in $counts) {
    Write-Host ("  {0,-15} {1,5}" -f $count.Name, $count.Count)
}

if (-not $SkipContentCheck) {
    $linkAttentionCounts = $linkRows |
        Where-Object { -not [string]::IsNullOrWhiteSpace([string]$_.Aandacht) } |
        Group-Object Aandacht |
        Sort-Object Name

    Write-Host ""
    Write-Host "Samenvatting hyperlinks:" -ForegroundColor Cyan
    foreach ($count in $linkAttentionCounts) {
        Write-Host ("  {0,-15} {1,5}" -f $count.Name, $count.Count)
    }

    Write-Host ""
    Write-Host "Open voor de gevraagde inventarisatie vooral '$linkOccurrencesCsv' in Excel." -ForegroundColor Yellow
    Write-Host "Gebruik '$linkSummaryCsv' daarnaast voor de technische samenvatting en foutclassificatie." -ForegroundColor DarkYellow
}
