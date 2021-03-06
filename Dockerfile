# escape=`

ARG BASE_TAG=win10_1803

FROM mback2k/windows-sdk:${BASE_TAG}

SHELL ["powershell", "-command"]

RUN Invoke-WebRequest "https://aka.ms/vs/15/release/vs_buildtools.exe" -OutFile "C:\Windows\Temp\vs_buildtools.exe"; `
    Start-Process -FilePath "C:\Windows\Temp\vs_buildtools.exe" -ArgumentList --quiet, --add, Microsoft.VisualStudio.Workload.VCTools, --nocache, --wait -NoNewWindow -PassThru -Wait; `
    Remove-Item @('C:\Windows\Temp\*', 'C:\Users\*\Appdata\Local\Temp\*') -Force -Recurse; `
    Write-Host 'Checking PATH and INCLUDE ...'; `
    Get-Item -Path 'C:\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools\MSBuild\15.0\Bin'; `
    Get-Item -Path 'C:\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools\VC\Tools\MSVC\14.15.26726\include';

RUN Write-Host 'Updating PATH and INCLUDE ...'; `
    $env:PATH = 'C:\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools\MSBuild\15.0\Bin;' + $env:PATH; `
    $env:INCLUDE = 'C:\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools\VC\Tools\MSVC\14.15.26726\include;' + $env:INCLUDE; `
    [Environment]::SetEnvironmentVariable('PATH', $env:PATH, [EnvironmentVariableTarget]::Machine); `
    [Environment]::SetEnvironmentVariable('INCLUDE', $env:INCLUDE, [EnvironmentVariableTarget]::Machine);

CMD ["powershell"]
