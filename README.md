Koch Polygons
================

This is a program written in processing that draws fractal like shapes with a algorthim based off the koch snowflake.

Examples of these can be found <a href="http://carbonbasedartform.tumblr.com/post/86906931928/docker-poly-3-fold-tools-processing">here</a>, <a href="http://carbonbasedartform.tumblr.com/post/77494679896/bounded-omni-gon-n2-medium-digital-tools">here</a>, and <a href="http://carbonbasedartform.tumblr.com/post/77452702375/bounded-omni-gon-n1-medium-digital-tools">here</a>.

The program begins by constructing an n-sided polygon (where n is specified by the *polygon_sides* variable in the config). It then splits each side segment according to the pattern given in the config, further explaination of this pattern is provided below. This process is repeated several times as specified by the *iterations* variable in the config.

The splitting pattern is quite simple to grasp. In the config it is encoded as a list of points bounded between x = 0.0 - 1.0 and y = -0.5 - 0.5. It is perhaps best explained using a diagram:
<img src="https://dl.dropboxusercontent.com/u/12265439/split_pattern.png"</img>
Each point creates a new segment from the last point. (The points (0.0, 0.0) and (1.0, 0.0) are added automatically to the beginning and end). Thus {{0.5, 0.2}} splits a segment into two new segments, where the new segments are placed at (0.0, 0.0) -> (0.5, 0.2) and (0.5, 0.2) -> (1.0, 0.0). In this model (0.0, 0.0) and (1.0, 0.0) are the previous segment's endpoints.

Using this pattern scheme a koch snowflake's splitting pattern would be {{0.3333, 0.0}, {0.5, 0.2886 (the altitude of an equilateral triangle with sides 1.0)}, {0.6666, 0.0}}.

Useage
=================

This program can either be used in the processing IDE (found <a href="https://www.processing.org/download/">here</a>) or as an exported project from the IDE. I recommend the export despite the fact that rendering in the IDE is faster, because for some stupid reason the IDE doesn't support printing carriage returns.

All the setting above (including image resolution) can be changed in the Koch.cfg file. Keep in mind that the algorithm scales exponentially, meaning high iteration values paired with large split patterns can result in long calculation times.