
function [] = displayRegions(regions)
    hold on
    for object = 1:length(regions)
        bb = regions(object).BoundingBox;
        bc = regions(object).Centroid;
        rectangle('Position', bb, 'EdgeColor', 'r', 'LineWidth', 1)
        plot(bc(1), bc(2), '-m+')
        a=text(bc(1) + 15, bc(2), strcat('X: ', num2str(round(bc(1))), '    Y: ', num2str(round(bc(2)))));
        set(a, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 12, 'Color', 'yellow');
    end
    hold off
end