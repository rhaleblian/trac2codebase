require 'uri'
require 'net/http'

def query(uri)
  url = URI.parse("http://yoyodyne.codebasehq.com/" + uri)
  req = Net::HTTP::Get.new(url.path)
  req.basic_auth('account/rhaleblian', '74ulhpgpt9v6827di7utu4emj6ucxtc4c5f5lwav')
  req.add_field('Content-type', 'application/xml')
  req.add_field('Accept', 'application/xml')
  xml = ""

  res = Net::HTTP.new(url.host, url.port).start {|http| http.request(req, xml)}
  case res
  when Net::HTTPCreated
    puts "Record was created successfully."
    puts res
  else
    puts "An error occurred querying records."
    puts res
  end
end

query("/samchill/tickets")
query("/beathive/milestones")
