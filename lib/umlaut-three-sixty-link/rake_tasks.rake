
namespace :umlaut do
  desc "Clear requests"
  task clear: :environment  do
    Request.all.each do |r|
      r.delete
    end
  end
end