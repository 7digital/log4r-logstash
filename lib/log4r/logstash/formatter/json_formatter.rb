require "json"
require "time"

module Log4r
  module Logstash
    class JsonFormatter
      def self.format(logevent, index,
                      data_field_name = "data",
                      level_field_name = "level",
                      fields = {},
                      additional_fields_proc = nil)
        data = {}
        data["type"] = logevent.class.to_s
        data["index"] = index.to_s
        data["timestamp"] = Time.now.getutc.iso8601
        data[level_field_name] = LNAMES[logevent.level]
        data[data_field_name] = logevent.data.force_encoding("UTF-8")
        data.merge! eval_map_proc_values(fields)
        data.merge! additional_fields_proc.call unless additional_fields_proc.nil?
        data.to_json
      end

      def self.eval_map_proc_values(map)
        map.map { |key, value| [key, value.class == Proc ? value.call : value] }.to_h
      end
    end
  end
end
