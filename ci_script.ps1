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
        build\windows\x64\runner\Release\counter.exe
    }
    default {
        echo "Invalid stage specified"
        exit 1
    }
}