require_relative "./plotter"
require_relative "./data_reader"

module KMeansClustering
  class Clusterer
    def initialize
      @data = DataReader.new("testSet.txt").read
    end

    def split_to_clusters(k)
      features_count = @data.size
      feature_size = @data.first.size
      clusterAssment = []
      features_count.times { clusterAssment << [0, 0] }
      centroids = random_centroids(k)
      clusterChanged = true
      while clusterChanged
        clusterChanged = false
        features_count.times do |i|
          minDist = 999999999; minIndex = -1
          k.times do |kth|
            dist_kth_i = find_distances(centroids[kth], @data[i])
            if dist_kth_i < minDist
              minDist = dist_kth_i
              minIndex = kth
            end
          end

          clusterChanged = (clusterAssment[i].first != minIndex)
          clusterAssment[i] = minIndex, minDist**2
        end

        puts "=============="
        puts centroids.inspect
        k.times do |j|
          points_in_cluster = []
          clusterAssment.each_with_index do |assignement, index|
            if assignement.first == j
              points_in_cluster << @data[index]
            end
          end


          cols = columns(points_in_cluster)
          feature_size.times do |f|
            mins ||= cols[f].min
            maxes ||= cols[f].max
            centroids[j][f] = mins + (maxes - mins)
          end
        end
      end
      [centroids, clusterAssment]
    end


    def plot
      Plotter.new(columns(@data)).plot
    end

    def find_distances(centroid, point)
      distances = 0
      point.each_with_index do |coordinate, i|
        sum = ((coordinate - centroid[i])**2)
        distances += sum**0.5
      end
      distances
    end

    def random_centroids(k)
      feature_size = @data.first.length
      centroids = []
      k.times do |i|
        centroids[i] = []
        feature_size.times do |j|
          mins ||= columns(@data)[j].min
          maxes ||= columns(@data)[j].max
          centroids[i][j] = mins + (maxes- mins) * (rand(10)/10.0)
        end
      end
      centroids
    end

    def columns(set)
      x_coordinates, y_coordinates = [], []
      set.each do |feature|
        x_coordinates << feature.first
        y_coordinates << feature.last
      end
      [x_coordinates, y_coordinates]
    end

  end
end

KMeansClustering::Clusterer.new.split_to_clusters(4)
