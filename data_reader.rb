module KMeansClustering
  class DataReader < Struct.new(:file)
    def read
      f = File.open(file, "r")
      data = f.each_line.inject([]) do |features, line|
        elements = line.split(/\t/)
        features << elements.map(&:to_f)
      end
    end
  end
end
