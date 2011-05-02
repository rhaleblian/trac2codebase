require 'uri'
require 'net/http'

url = URI.parse("http://yoyodyne.codebasehq.com/samchill/tickets")
req = Net::HTTP::Post.new(url.path)
req.basic_auth('account/rhaleblian', '74ulhpgpt9v6827di7utu4emj6ucxtc4c5f5lwav')
req.add_field('Content-type', 'application/xml')
req.add_field('Accept', 'application/xml')

xml = "<ticket><summary>My Example Ticket</summary><status-id>1234</status-id>
<priority-id>1234</priority-id><ticket-type>bug</ticket-type></ticket>"

res = Net::HTTP.new(url.host, url.port).start {|http| http.request(req, xml)}
case res
when Net::HTTPCreated
  puts "Record was created successfully."
else
  puts "An error occurred while adding this record"
end
