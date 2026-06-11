## Run Tests
	xcodebuild test \
	    -project ADClear.xcodeproj \
	    -scheme ADClear \
	    -testPlan ADClear \
	    -destination 'platform=iOS Simulator,name=iPhone 17 Pro,arch=arm64'
