module Slackistrano
  module Messaging
    class HighCo < Messaging::Base

      def application_url
        fetch(:application_url)
      end

      def deployer
        ENV['USER'] || ENV['USERNAME'] || fetch(:deployer)
      end

      def username
        "Astro"
      end

      def icon_url
        nil
      end

      def icon_emoji
        ":astro:"
      end

      def channels_for(action)
        if action == :failed
          "#ops"
        else
          super
        end
      end

      def payload_for_updating
        nil
      end

      def payload_for_reverting
        nil
      end

      def payload_for_updated
        {
          attachments: [{
            color: "good",
            title: ":white_check_mark: #{application} : Deploiement terminé",
            title_link: application_url,
            author_name: deployer,
            fields: [{
                title: "Environnement",
                value: stage,
                short: true
            }, {
                title: "Branche",
                value: branch,
                short: true
            }],
            fallback: "#{deployer} a déployé la branche #{branch} de #{application} en #{stage}"
          }]
        }
      end

      def payload_for_reverted
        {
          attachments: [{
            color: "warning",
            title: ":warning: #{application} : Rollback effectué",
            title_link: application_url,
            author_name: deployer,
            fields: [{
                title: "Environnement",
                value: stage,
                short: true
            }, {
                title: "Branche",
                value: branch,
                short: true
            }],
            fallback: "#{deployer} a rollbacker la branche #{branch} de #{application} en #{stage}"
          }]
        }
      end

      def payload_for_failed
        {
          attachments: [{
            color: "danger",
            title: ":no_entry_sign: #{application} : Echec lors du #{deploying? ? 'deploiement' : 'rollback'}",
            title_link: application_url,
            author_name: deployer,
            fields: [{
                title: "Environnement",
                value: stage,
                short: true
            }, {
                title: "Branche",
                value: branch,
                short: true
            }],
            fallback: "#{deployer} n'a pas réussi à #{deploying? ? 'déployer' : 'rollbacker'} la branche #{branch} de #{application} en #{stage}"
          }]
        }
      end
    end
  end
end