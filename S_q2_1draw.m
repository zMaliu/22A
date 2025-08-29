% 三维平面绘制及其投影效果
figure('Position', [100, 100, 800, 600]);

% 创建函数 y=x 的三维平面数据
[x, z] = meshgrid(linspace(-5, 5, 50));
y = x;

% 绘制三维平面
surf(x, y, z, 'FaceAlpha', 0.7, 'EdgeColor', 'none');
hold on;

% 绘制XY平面投影
surf(x, y, zeros(size(z)), 'FaceColor', 'r', 'FaceAlpha', 0.3, 'EdgeColor', 'none');

% 设置图形属性
grid on;
axis equal;
xlabel('X轴');
ylabel('Y轴');
zlabel('Z轴');
title('函数 y=x 的三维图形及其投影');
legend('三维平面 y=x', 'XY平面投影', 'Location', 'best');

% 添加网格和美化
set(gcf, 'Color', 'w');

% 显示数据信息
fprintf('平面数据信息:\n');
fprintf('网格尺寸: %d x %d\n', size(x,1), size(x,2));
fprintf('X范围: [%.2f, %.2f]\n', min(x(:)), max(x(:)));
fprintf('Y范围: [%.2f, %.2f]\n', min(y(:)), max(y(:)));
fprintf('Z范围: [%.2f, %.2f]\n', min(z(:)), max(z(:)));