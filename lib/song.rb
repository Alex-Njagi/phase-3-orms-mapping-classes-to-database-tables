class Song

  attr_accessor :name, :album, :id  #Macros for accessing the instance variables

  def initialize(name:, album:, id: nil)  #On each instance of the class
    @id = id  #Create an id variable and assign it to id
    @name = name  #Create a name variable and assign it to name
    @album = album  #Create an album variable and assign it to album
  end

  def self.create_table     #This is the class method that handles the initial creation of the songs table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS songs (
        id INTEGER PRIMARY KEY,
        name TEXT,
        album TEXT
    )
    SQL
    DB[:conn].execute(sql)  #This creates a connection with the database to execute the SQL code
  end

  def save      #This is an instance method that is used for saving the created Ruby elements and instances as data and as rows to the database
    sql = <<-SQL
      INSERT INTO songs (name, album)
        VALUES (?, ?)   #The two ? are used as placeholders
    SQL
    DB[:conn].execute(sql, self.name, self.album)   #Executes the SQL with the placeholders having their values inputted
  
  #This block saves the id to the database
  self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM songs")[0][0]
  self

  end

  #This block minimizes the need to save a record after creating it
  def self.create(name:, album:)
    song = Song.new(name: name, album: album)
    song.save   #Calls the instance method for saving songs to the database
  end

end
