module RequestSpecHelper
  # Parsing json for controller specs

  def json
    JSON.parse(response.body)
  end
end
