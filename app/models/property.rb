class Property < ApplicationRecord
  belongs_to :user
  has_many_attached :images
  
  validates :price, presence: true,
                    numericality: { only_integer: true, greater_than: 0 }
  validates :direction, presence: true,
                        length: { minimum: 6 }
  validates :area, presence: true, 
                  numericality: { only_integer: true }
  validates :room_number, presence: true, 
                          numericality: { only_integer: true }
  validates :bathroom_number, presence: true, 
                              numericality: { only_integer: true }
  validates :user_id, presence: true
  validates :images, attached: true, content_type: { 
    in: [
      :png, :jpg, :jpeg
    ], 
    message: 'Not a valid format. Must be: .png, .jpg, or .jpeg'
  }

  default_scope { order(created_at: :desc) }
  scope :by_address, -> (direction) { where('lower(direction) LIKE ?', "%#{direction.downcase}%") }
  scope :by_room_number, -> (room_number) { (!room_number.nil?) ? where('(room_number) = ?', room_number) : all }
  scope :by_bathroom_number, -> (bathroom_number) { (!bathroom_number.nil?) ? where('(bathroom_number) = ?', bathroom_number) : all }

  def thumbnail
    return self.images.first.variant(resize: "300x200").processed
  end

  def medium_first
    return self.images[0].variant(resize: "600x600").processed
  end

  def medium_second
    return self.images[1].variant(resize: "600x600").processed
  end

  def medium_third
    return self.images[2].variant(resize: "600x600").processed
  end
end
