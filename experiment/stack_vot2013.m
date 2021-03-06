function experiments = stack_vot2013()

set_global_variable('bundle', 'http://box.vicos.si/vot/vot2013.zip');
set_global_variable('repeat', 15);
set_global_variable('burnin', 10);
set_global_variable('skipping', 5);

baseline.name = 'baseline';
baseline.converter = [];
baseline.execution = 'default';
baseline.labels = {'camera_motion', 'illum_change', 'occlusion', 'size', ...
    'motion', 'empty'};

region_noise.name = 'region_noise';
region_noise.converter = @(sequence) sequence_transform_initialization(...
    sequence, @noisy_transform);
region_noise.execution = 'default';
region_noise.labels = {'camera_motion', 'illum_change', 'occlusion', 'size', ...
    'motion', 'empty'};

grayscale.name = 'grayscale';
grayscale.converter = 'sequence_grayscale';
grayscale.execution = 'default';
grayscale.labels = {'camera_motion', 'illum_change', 'occlusion', 'size', ...
    'motion', 'empty'};

experiments = {baseline, region_noise, grayscale};

end

function [transform] = noisy_transform(sequence, index, context)

    bounds = region_convert(get_region(sequence, index), 'rectangle');

    scale = 0.9 + rand(1, 2) * 0.2;
    move = bounds(3:4) .* (0.1 - rand(1, 2) * 0.2);

    transform = [scale(1), 0, move(1); 0, scale(2), move(2); 0, 0, 1];

end