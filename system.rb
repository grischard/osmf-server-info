require 'json'

nodes = JSON.parse(IO.read('_data/nodes.json'))

nodes['rows'].each do |server|
  name = server['name']

  if server['automatic']['virtualization'] &&
     server['automatic']['virtualization']['role'] == 'guest'
  else
    if server['automatic']['dmi']['system'] &&
       server['automatic']['dmi']['system']['manufacturer'] != 'empty' &&
       server['automatic']['dmi']['system']['manufacturer'] != 'System manufacturer'
      system_manufacturer = server['automatic']['dmi']['system']['manufacturer'].strip
      system_product = server['automatic']['dmi']['system']['product_name'].gsub(/\s+/, " ").strip
      system_sku = server['automatic']['dmi']['system']['sku_number'].strip
    end

    if server['automatic']['dmi']['base_board'] &&
       server['automatic']['dmi']['base_board']['product_name']
      base_board_manufacturer = server['automatic']['dmi']['base_board']['manufacturer'].strip
      base_board_product = server['automatic']['dmi']['base_board']['product_name'].gsub(/\s+/, " ").strip
    end

    if system_manufacturer == base_board_manufacturer &&
       system_product == base_board_product
      system_manufacturer = nil
      system_product = nil
    end

    if system_manufacturer == 'IBM'
      system_product.sub!(/\s*-\[([0-9]{4})([A-Z]{3})\]-$/, ' \1-\2')
    end

    # if system_manufacturer && system_product
    #   if system_manufacturer == 'HP' && system_sku != ''
    #     puts "#{system_manufacturer} #{system_product} (#{system_sku})"
    #   elsif system_product.start_with?(system_manufacturer)
    #     puts "#{system_product}"
    #   else
    #     puts "#{system_manufacturer} #{system_product}"
    #   end
    # end

    if base_board_manufacturer && base_board_product
      puts "#{base_board_manufacturer} #{base_board_product}"
    end
  end
end
