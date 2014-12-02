module VotesHelper
  def vote_id(object)
    "#{send("#{object.class.name.downcase}_id",object)}-vote"
  end
end