Dir.glob(File.expand_path("../use_cases/*.rb", __FILE__)).each do |file|
  puts "requiring #{file}"
  require file
end

run ->(env) {
  GetResource.new(env).respond!
}