module Dorsum
  abstract class Connection
    abstract def gets
    abstract def puts(data : String)
  end
end
