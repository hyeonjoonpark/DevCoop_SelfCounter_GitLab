param (
    [string]$stage
)

cd C:\Users\KB\Devcoop

switch ($stage) {
    "setup" {
        echo "Setting up Flutter environment..."
        flutter --version
    }
    "build" {
        echo "Running pub get..."
        flutter pub get
        echo "Building the Flutter application..."
        flutter build windows --release
    }
    "deploy" {
        echo "Deploying the application..."
        # 배포 스크립트 추가 (예: 앱 스토어 배포, 서버에 업로드 등)
    }
    default {
        echo "Invalid stage specified"
        exit 1
    }
}