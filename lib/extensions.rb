class Float
  def prettify
    to_i == self.round(2) ? to_i : self.round(2)
  end
end