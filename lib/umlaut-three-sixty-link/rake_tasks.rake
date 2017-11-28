# Copyright (c) 2016, Regents of the University of Michigan.
# All rights reserved. See LICENSE.txt for details.

namespace :umlaut do
  desc 'Clear requests'
  task clear: :environment do
    Request.all.each(&:delete)
    Referent.all.each(&:delete)
  end

  namespace :"360link" do
    desc 'Ingest database priorities'
    task :priorities, [:details, :order, :output] do |_, args|
      require 'csv'
      require 'simple_xlsx_reader'
      require 'yaml'

      mapping = {
        weight: {},
        provider: {}
      }

      if args[:details].match(/\.xlsx$/)
        details = SimpleXlsxReader.open(args[:details]).sheets.first.rows
      elsif args[:details].match(/\.csv$/)
        details = CSV.read(args[:details], encoding: 'binary:UTF-8')
      end
      details.shift
      names_to_codes = {}
      details.each do |row|
        names_to_codes[row[0]] = row[0]
        names_to_codes[row[1]] = row[0]
        names_to_codes[row[2]] = row[0]
        mapping[:provider][row[0]] = row[4]
      end

      if args[:order].match(/\.xlsx$/)
        order = SimpleXlsxReader.open(args[:order]).sheets.first.rows
      elsif args[:order].match(/\.csv$/)
        order = CSV.read(args[:order], encoding: 'binary:UTF-8')
      end
      order.shift

      order.each do |row|
        mapping[:weight][names_to_codes[row[1]]] = row[0].to_i
      end

      IO.write(args[:output], mapping.to_yaml)
    end
  end
end
