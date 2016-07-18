
namespace :umlaut do
  desc 'Clear requests'
  task clear: :environment do
    Request.all.each(&:delete)
    Referent.all.each(&:delete)
  end
end
