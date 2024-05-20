param (
    [string]$stage
)
cd C:\Users\KB\Devcoop\devcoop_self_counter_v1

# 환경 변수 읽기
$env:DB_HOST = $env:DB_HOST
echo "DB_HOST: $env:DB_HOST"

switch ($stage) {
    "setup" {
        echo "Setting up Flutter environment..."
        flutter --version
        git pull
    }
    "build" {
        echo "Running pub get..."
        # 기존 프로세스 종료 (counter.exe)
        $process = Get-Process -Name "counter" -ErrorAction SilentlyContinue
        if ($process) {
            echo "Stopping existing counter.exe process..."
            Stop-Process -Name "counter" -Force
        } else {
            echo "No existing counter.exe process found."
        }
        flutter pub get
        echo "Building the Flutter application..."
        flutter build windows --release --dart-define=DB_HOST=$env:DB_HOST
    }
    "deploy" {
        echo "Deploying the application..."

        # 기존 프로세스 종료 (counter.exe)
        $process = Get-Process -Name "counter" -ErrorAction SilentlyContinue
        if ($process) {
            echo "Stopping existing counter.exe process..."
            Stop-Process -Name "counter" -Force
        } else {
            echo "No existing counter.exe process found."
        }

        # 수동으로 생성한 작업 스케줄러 작업 실행
        $taskName = "StartCounterExeTask"
        schtasks /run /tn $taskName
    }
    default {
        echo "Invalid stage specified"
        exit 1
    }
}
