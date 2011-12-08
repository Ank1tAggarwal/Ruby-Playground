class Book
  attr_accessor :title, :author, :chapters
  
  def initialize(details = nil)
    if(details)
      @title = details[:title]
      @author = details[:author]
    end
    @chapters = []
  end
end

# This cannot be nested in the Book class because of the code that will be executed
class Chapter
  attr_accessor :title
  
  def initialize(title)
    @title = title
  end
end