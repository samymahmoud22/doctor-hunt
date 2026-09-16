$files = @("onboarding1.svg", "onboarding2.svg", "onboarding3.svg")
for ($i = 0; $i -lt $files.Length; $i++) {
    $content = Get-Content "assets/images/$($files[$i])" -Raw
    $idx = $content.IndexOf("data:image/jpeg;base64,")
    if ($idx -ge 0) {
        $start = $idx + "data:image/jpeg;base64,".Length
        $end = $content.IndexOf('"', $start)
        $b64 = $content.Substring($start, $end - $start)
        $bytes = [System.Convert]::FromBase64String($b64)
        $outPath = "assets/images/onboarding$($i+1).jpg"
        [System.IO.File]::WriteAllBytes($outPath, $bytes)
        Write-Host "Saved $outPath ($($bytes.Length) bytes)"
    }
}
