
namespace :umlaut do
  desc 'Clear requests'
  task clear: :environment do
    Request.all.each(&:delete)
    Referent.all.each(&:delete)
  end

  namespace :"360link" do
    desc 'Ingest database priorities'
    task :priorities, [:details, :order, :output] do |t, args|
      require 'csv'
      require 'yaml'

      mapping = {
        weight: {},
        provider: {}
      }

      details = CSV.read(args[:details])
      details.shift
      names_to_codes = {}
      details.each do |row|
        names_to_codes[row[0]] = row[0]
        names_to_codes[row[1]] = row[0]
        names_to_codes[row[2]] = row[0]
        mapping[:provider][row[0]] = row[4]
      end

      order  = CSV.read(args[:order])
      order.shift

      order.each do |row|
        mapping[:weight][names_to_codes[row[1]]] = row[0].to_i
      end

      IO.write(args[:output], mapping.to_yaml)
    end
  end
end
