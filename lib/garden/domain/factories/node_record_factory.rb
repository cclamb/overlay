class Garden::Domain::Factories::NodeRecordFactory

  def create_node_record values
    node_record = {}
    values.each_key { |key| node_record[key.to_sym] = values[key] }
    node_record[:id] = node_record[:hostname]
    node_record
  end

end