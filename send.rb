require 'net/http'
require 'rexml/document'
require 'uri'

def send(section, element)
  project = 'http://yoyodyne.codebasehq.com/samchill'
  username = 'rhaleblian'
  apikey = 'blarg'

  formatter = REXML::Formatters::Default.new()
  rep = ""
  formatter.write(element, rep)
  puts rep

  uri = project + section
  url = URI.parse(uri)
  req = Net::HTTP::Post.new(url.path)
  req.basic_auth('account/rhaleblian', apikey)
  req.add_field('Content-type', 'application/xml')
  req.add_field('Accept', 'application/xml')
  element = '<?xml version="1.0" encoding="UTF-8"?>' + element
  res = Net::HTTP.new(url.host, url.port).start {|http| http.request(req, element)}
  puts res
  case res
  when Net::HTTPCreated
    puts "This record was created successfully."
  else
    puts "An error occurred while adding this record"
  end
end

fp = open('out.xml')
xml = fp.read
doc = REXML::Document.new(xml)
#doc.elements.each('project/ticketing-status') do |ele|
#  send('/tickets/statuses', ele)
#end
#doc.elements.each('project/ticketing-priority') do |ele|
#  send('/tickets/priorities', ele)
#end
doc.elements.each('project/ticketing-milestone') do |ele|
  send('/milestones', ele)
end
