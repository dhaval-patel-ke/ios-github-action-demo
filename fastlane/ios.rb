
@configuration = nil
def read_ios_params(options)
    @configuration = YAML.load_file('props.yaml')
    if(@configuration == nil)
        UI.user_error!("File ./props.yaml not found")
    end

    config = ENV['config'] # or use options[:config]
    if config == nil
        config = options[:config]
    end

    if config != nil
        read_config_properties(config)
    else
        UI.user_error!("Missing config param")
    end

end

def read_config_properties(flavor)
    puts "Reading config properties for env: #{ flavor }"
    @configuration = @configuration["configurations"]["#{ flavor }"]
    if(@configuration == nil)
        UI.user_error!("Environment not found for value: #{ flavor }")
    end
end

private_lane :build_adhoc_app do
    build_app(
        scheme: @configuration['export_scheme'],
        export_method: "ad-hoc",
        export_options: {
          provisioningProfiles: {
            @configuration['bundle_identifier'] => @configuration['provisioning_profile_firebase'],
          }
        }
    )
end

#https://docs.fastlane.tools/actions/build_app/
private_lane :build_appstore_app do
    settings_to_override = {
        :BUNDLE_IDENTIFIER => @configuration['bundle_identifier'],
        :PROVISIONING_PROFILE_SPECIFIER => @configuration['provisioning_profile_appstore'],
    }

    build_app(
        clean: false,
        skip_profile_detection: false,
        codesigning_identity: "Apple Distribution",
        scheme: @configuration['export_scheme'],
        xcargs: settings_to_override,
        export_method: "app-store",
        export_options: {
          provisioningProfiles: {
            @configuration['bundle_identifier'] => @configuration['provisioning_profile_appstore'],
          }
        }
    )
end

# https://firebase.google.com/docs/app-distribution/android/distribute-fastlane
def firebase_app_deploy()
    release_note = sh('git log -1 --format=%B')
    puts release_note
    firebase_app_id = @configuration['firebase_app_id']
    firebase_app_distribution(
        app: firebase_app_id,
        groups: "kernelequity",
        release_notes: release_note,
        service_credentials_file: "./firebase_service_account.json",
    )
end

# https://docs.fastlane.tools/actions/upload_to_app_store/
def appstore_app_deploy()
    release_note = sh('git log -1 --format=%B')
    puts release_note
    firebase_app_id = @configuration['firebase_app_id']
    upload_to_app_store(
         app_identifier: @configuration['bundle_identifier'],
         api_key: "sample_key"
    )
end
