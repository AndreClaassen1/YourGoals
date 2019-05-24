# Uncomment this line to define a global platform for your project
platform :ios, '12.0'
# Uncomment this line if you're using Swift
# Achtung: 5.11.2018Aktuell wird die Swift Version überschrieben. Eureka arbeitet auf 4.2.
#          Das muss noch händisch nach pod install nachgetragen werden.
use_frameworks!

target 'YourGoals' do
    pod 'MGSwipeTableCell'
    pod 'CSNotificationView'
    pod 'BEMSimpleLineGraph'
    pod 'TEAChart'
    pod 'PNChart'
    pod 'Eureka'
    pod 'SwiftGen'
    #    pod 'ACTabScrollView'
end

target 'YourGoalsTests' do
    pod 'Eureka'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        if ['ChaosProjekt'].include? target.name
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '3.2'
            end
        end
    end
end
