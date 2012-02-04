require_relative "./plotter"
require_relative "./data_reader"

module KMeansClustering
  class Clusterer
    attr_accessor :data, :features_number, :feature_size

    def initialize
      @data = DataReader.new("testSet.txt").read
      @features_count = @data.size
      @feature_size = @data.first.size
    end

    def split_to_clusters(k)
      cluster_assignements = []
      @features_count.times { cluster_assignements << [0, 0] }

      centroids = random_centroids(k)

      cluster_changed = true
      while cluster_changed
        cluster_changed = false
        @features_count.times do |i|
          minimal_distance = 9999; minimal_index = -1
          k.times do |kth|
            dist_kth_i = find_distances(centroids[kth], @data[i])
            if dist_kth_i < minimal_distance
              minimal_distance = dist_kth_i
              minimal_index = kth
            end
          end
          cluster_changed = (cluster_assignements[i].first != minimal_index)
          cluster_assignements[i] = minimal_index, minimal_distance**2
        end

        
        k.times do |cent|
          points_in_cluster = []
          cluster_assignements.each_with_index do |assignement, index|
            if assignement.first == cent
              points_in_cluster << @data[index]
            end
          end


          cols = columns(points_in_cluster)
          @feature_size.times do |f|
            sum = cols[f].inject(:+)
            centroids[cent][f] = sum / cols[f].size
          end
        end


      end
      [centroids, cluster_assignements]
    end


    def plot
      Plotter.new(columns(@data)).plot
    end

    def find_distances(centroid, point)
      distances = 0
      point.each_with_index do |coordinate, i|
        sum = ((coordinate - centroid[i])**2)
        distances += sum
      end
      distances**0.5
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
