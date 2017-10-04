# pointless comment for rubocop
class Station

  def initialize(info)
    @info = info
  end

  def name
    @info[:name]
  end

  def zone
    @info[:zone]
  end
end
