param (
    [string]$stage
)

cd C:\Users\KB\Devcoop

switch ($stage) {
    "setup" {
        echo "Setting up Flutter environment..."
        flutter --version
        git pull
    }
    "build" {
        echo "Running pub get..."
        flutter pub get
        echo "Building the Flutter application..."
        flutter build windows --release
    }
    "deploy" {
        echo "Deploying the application..."
        # 기존 프로세스 종료
        $process = Get-Process -Name "counter" -ErrorAction SilentlyContinue
        if ($process) {
            echo "Stopping existing counter.exe process..."
            Stop-Process -Name "counter" -Force
        } else {
            echo "No existing counter.exe process found."
        }
        
        # 새로운 프로세스 시작
        $exePath = "C:\Users\KB\Devcoop\build\windows\x64\runner\Release\counter.exe"
        if (Test-Path $exePath) {
            echo "Starting new counter.exe process..."
            Start-Process -FilePath $exePath
        } else {
            echo "counter.exe not found at $exePath"
            exit 1
        }
    }
    default {
        echo "Invalid stage specified"
        exit 1
    }
}
