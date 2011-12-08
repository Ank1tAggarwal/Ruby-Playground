class Dungeon
  attr_accessor :player
  
  def initialize(player_name)
    @player = Player.new(player_name)
    @rooms = []
  end
  
  # Description of surroundings
  def show_current_description
    find_room_in_dungeon(@player.location).room_description
    display_room_items
  end
  
  # Initial Setup
  # Adding Rooms
  def add_room(reference, name, description, connections)
    new_room = Room.new(reference, name, description, connections) 
    @rooms << new_room
    return new_room
  end
  
  def start(location)
    @player.location = location
    show_current_description
  end

  # Adding and removing items from rooms
  private
  def remove_item_from_room(item, location)
    find_room_in_dungeon(location).items.delete(item)
  end
  
  def move_item_to_room(item, location)
    find_room_in_dungeon(location).items << item
  end
  
  # Returning object references
  def find_room_in_dungeon(reference)
    @rooms.detect { |room| room.reference == reference }
  end
  
  def find_room_in_direction(direction)
    find_room_in_dungeon(@player.location).connections[direction]
  end
  
  def get_item_from_room(reference, location)
    find_room_in_dungeon(location).items.detect { |item| item[:reference] == reference }
  end
  
  def get_item_from_player(reference)
    @player.items.detect { |item| item[:reference] == reference }
  end
  
  public
  # Player options
  def go(direction)
    puts "You go " + direction.to_s
    if(find_room_in_direction(direction))
      @player.location = find_room_in_direction(direction)
      if(@player.location == :exit)
        puts "You are on your way out. Good bye."
      else
        show_current_description
      end
    else
      puts "There's no room in that direction!"
    end
  end
  
  def pick_up_item(reference)
    item = get_item_from_room(reference, @player.location)
    if (item)
      remove_item_from_room(item, @player.location) if (@player.equip(item))
    else 
      puts "Item does not exist! Invalid request."
    end
  end
  
  def drop_item(reference)
    item = get_item_from_player(reference)
    if (item)
      move_item_to_room(item, @player.location) if (@player.unequip(item))
    else
      puts "Item does not exist! Invalid request."
    end
  end
  
  def display_inventory
    puts "You have the following items:"
    @player.items.each { |item|
      puts item[:reference].to_s + ": " + item[:description] + ". Weighs " + item[:weight].to_s
    }
  end
  
  def display_room_items
    puts "This room has the following items:"
    find_room_in_dungeon(@player.location).items.each { |item| puts item[:reference].to_s + ": " + item[:description] }
  end
  
  # Nested Classes
  class Player
    attr_accessor :name, :location, :items, :carry
    
    def initialize(name)
      @name = name
      @items = []
      @carry = 0
    end
    
    def equip(item)
      if(@carry + item[:weight] > 10)
        puts "You cannot carry any more items!"
        return false
      else
        @items << item
        @carry += item[:weight]
        puts "You have added #{item[:description]} to your inventory"
        return true
      end
    end
    
    def unequip(item)
      if (@items.include? item)
        @items.delete(item)
        @carry -= item[:weight]
        puts "You just dropped #{item[:description]}"
        return true
      else
        puts "You don't have this item!"
        return false
      end
    end
    
  end
  
  class Room
    attr_accessor :reference, :name, :description, :connections, :items
  
    def initialize(reference, name, description, connections)
      @reference = reference
      @name = name
      @description = description
      @connections = connections
      @items = []
    end
    
    def add_item(reference, name, description, weight)
      @items << Item.new(reference, name, description, weight)
    end
    
    def room_description
        directions = @connections.keys
        puts @name + "\nYou are in " + @description
        puts "You can travel in the following directions: " + directions.join(", ")
    end
  end
  
  Item = Struct.new(:reference, :name, :description, :weight)
end

# Create the main dungeon object
my_dungeon = Dungeon.new("Shaan Batra")

# Add rooms to the dungeon with items
largeRoom = my_dungeon.add_room(:largecave, "Large Cave", "a large cavernous cave", {:north => :anothercave,:west => :smallcave, :south => :exit })
largeRoom.add_item(:gold, "Gold", "a small pile of gold", 2)
largeRoom.add_item(:scroll, "Scroll", "an emtpy scroll", 1)

anotherRoom = my_dungeon.add_room(:anothercave, "Another Cave", "another, large cave (I know not too creative here)", {:south => :largecave, :east => :prison})
anotherRoom.add_item(:axe, "Axe", "an Orc battleaxe", 8)

prisonRoom = my_dungeon.add_room(:prison, "Prison Cell", "scary, place with evil creatures locked up behind bars", {:west => :anothercave, :south => :treasurecave})
prisonRoom.add_item(:scroll_of_light, "Scroll of Light", "an interesting magical spell", 1)
prisonRoom.add_item(:ruined_book, "Ruined Book", "a ruined book", 3)

treasureRoom = my_dungeon.add_room(:treasurecave, "Treasure Room", "not the best looking place, but lots of gold lying around", {:west => :largecave})
treasureRoom.add_item(:big_gold, "Lots of Gold", "a ton of gold!", 5)

exitRoom = my_dungeon.add_room(:exit, "Exit", "The way out", {:north => :largecave})

smallRoom = my_dungeon.add_room(:smallcave, "Small Cave", "a small, claustrophobic cave", {:east => :largecave })
smallRoom.add_item(:shield, "Shield", "an Orc shield", 6)


# Start the dungeon by placing the player in the large cave

puts "Welcome player. You have come for gold and glory. Enter at your own peril. In order to exit the game you must exit the dungeon. Simply head south from the Large Cave."
puts "Here are your options in every room:"
puts "Type 'go [direction]' in order to travel to another room. Example: go west."
puts "Type 'pick [item name]' in order to pick up an item. Example: pick axe."
puts "Type 'drop [item name]' in order to drop an item. Example: drop scroll."
puts "Type 'display inventory' to see the items you have in your inventory"
puts "Ready? Type 'yes' if you are or anything else if you are not."

if (gets.chomp) == "yes"

  my_dungeon.start(:largecave)

  loop do
    
    break if (my_dungeon.player.location == :exit) 
    
    action = gets.chomp
    if (action =~ /^go /)
      direction = action.split(' ')[1].to_sym
      my_dungeon.go(direction)
    elsif (action =~ /^pick /)
      item = action.split(' ')[1].to_sym
      my_dungeon.pick_up_item(item)
    elsif (action =~ /^drop /)
      item = action.split(' ')[1].to_sym
      my_dungeon.drop_item(item)
    elsif (action == 'display inventory')
      my_dungeon.display_inventory
    end
  end

else 
  exit
end