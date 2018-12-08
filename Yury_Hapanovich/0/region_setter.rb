# The class helps you to change current region.
class RegionSetter
  def initialize(regions)
    @regions = regions
  end

  def set_current_region
    puts 'Please, select a region: '
    write_regions_list
    select_region
  end

  def write_regions_list
    @regions.each_key do |region|
      puts region.to_s
    end
  end

  def select_region
    loop do
      region = gets.chomp
      return region if @regions.key?(region)

      puts 'Please, select correct region!'
    end
  end
end
