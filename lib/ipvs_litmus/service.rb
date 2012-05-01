module IPVSLitmus
  class Service
    def initialize(name, dependencies = [], checks = [])
      @name = name
      @dependencies = dependencies
      @checks = checks
    end

    def success?
      health > 0
    end

    def current_health
      forced_health = _determine_forced_health
      return forced_health unless forced_health.nil?

      health = IPVSLitmus::Health.new
      @dependencies.each do |dependency|
        health.ensure(dependency)
      end

      @checks.each do |check|
        health.perform(check)
      end
      health
    end

    def measure_health(metric_class, options)
      @checks << metric_class.new(options[:weight])
    end

    def depends(dependency_class, *args)
      @dependencies << dependency_class.new(*args)
    end

    def _health_files
      @health_files ||= [
        [0, IPVSLitmus::StatusFile.new('down', @name)],
        [100, IPVSLitmus::StatusFile.new('up', @name)],
        [0, IPVSLitmus::StatusFile.new('global_down')],
        [100, IPVSLitmus::StatusFile.new('global_up')]
      ]
    end

    def _determine_forced_health
      _health_files.map do |health, status_file|
        ForcedHealth.new(health, status_file.content) if status_file.exists?
      end.compact.first
    end
  end
end
