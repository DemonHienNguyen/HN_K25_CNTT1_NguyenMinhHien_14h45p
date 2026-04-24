-- HN_K25_CNTT1_NGUYỄN MINH HIỂN_TGAIN NỘP_ 14h:45
DROP DATABASE IF EXISTS `Hackathon`;

-- TẠO DATABASE 
CREATE DATABASE `Hackathon`;
USE `Hackathon`;

-- TẠO CẤU TRÚC BẢNG
-- TẠO BẢNG Customers
CREATE TABLE `Customers`(
	`customer_id` VARCHAR(5) PRIMARY KEY,
	`full_name` VARCHAR(100) NOT NULL,
    `email` VARCHAR(100) NOT NULL UNIQUE,
    `phone` VARCHAR(15) NOT NULL UNIQUE 
);

-- TẠO BẢNG Brands
CREATE TABLE `Brands`(
	`brand_id` VARCHAR(5) PRIMARY KEY,
    `brand_name` VARCHAR(100) NOT NULL UNIQUE
);

-- TẠO BẢNG Products
CREATE TABLE `Products`(
	`product_id` VARCHAR(5) PRIMARY KEY,
    `product_name` VARCHAR(100) NOT NULL UNIQUE,
    `brand_id` VARCHAR(5) NOT NULL,
    `price` DECIMAL(10, 2) NOT NULL,
    `stock` INT NOT NULL,
    CONSTRAINT `fk_Brand_Product`
    FOREIGN KEY (`brand_id`) REFERENCES `Brands`(`brand_id`)
);

-- TẠO BẢNG Orders
CREATE TABLE `Orders`(
	`order_id` INT PRIMARY KEY AUTO_INCREMENT,
    `customer_id` VARCHAR(5) NOT NULL,
    `product_id` VARCHAR(5) NOT NULL,
    `status` VARCHAR(20) CHECK (`status` IN ('Pending', 'Completed', 'Cancelled')) NOT NULL,
    `order_date` DATE,
    CONSTRAINT `fk_Customer_Order`
    FOREIGN KEY (`customer_id`) REFERENCES `Customers`(`customer_id`),
    CONSTRAINT `fk_Product_Order`
    FOREIGN KEY (`product_id`) REFERENCES `Products`(`product_id`)
);

-- THÊM DỮ LIỆU
-- THÊM DỮ LIỆU VÀO BẢNG `customer`
INSERT INTO `customers`
VALUES
	('C01', 'Nguyễn Văn An', 'an.nv@gmail.com', '0911111111'),
    ('C02', 'Nguyễn Thị Mai', 'mai.nt@gmail.com', '0922222222'),
    ('C03', 'Trần Quang Hải', 'hai.tq@gmail.com', '0933333333'),
    ('C04', 'Phạm Bảo Ngọc', 'ngoc.pb@gmail.com', '0944444444'),
    ('C05', 'Vũ Đức Đam', 'dam.vd@gmail.com', '0955555555');
    
-- THÊM DỮ LIỆU VÀO BẢNG `brands`
INSERT INTO `brands`
VALUES
	('B01', 'Apple'),
    ('B02', 'Samsung'),
    ('B03', 'Sony'),
    ('B04', 'Dell');


-- THÊM DỮ LIỆU VÀO BẢNG `products`
INSERT INTO `products`
VALUES
	('P01', 'iPhone 15 Pro Max', 'B01', 30000000.00, 10),
    ('P02', 'MacBook Pro M3', 'B01', 45000000.00, 5),
    ('P03', 'Galaxy S24 Ultra', 'B02', 25000000.00, 20),
    ('P04', 'PlayStation 5', 'B03', 15000000.00, 8),
	('P05', 'Dell XPS 15', 'B04', 35000000.00, 15);

-- THÊM DỮ LIỆU VÀO BẢNG `orders`
INSERT INTO `orders`
VALUES
	(1, 'C01', 'P01', 'Pending', '2025-10-01'),
    (2, 'C02', 'P03', 'Completed', '2025-10-02'),
    (3, 'C01', 'P02', 'Completed', '2025-10-03'),
    (4, 'C04', 'P05', 'Cancelled', '2025-10-04'),
    (5, 'C05', 'P01', 'Pending', '2025-10-05');

-- 3 CẬP NHẬP VÀ XÓA DỮ LIỆU
-- AN TOÀN TẮT UPDATE ĐI
SET SQL_SAFE_UPDATES = 0;
--  tăng stock thêm 10 sản phẩm và tăng price lên 5%.

UPDATE `products`
SET `price` = `price` * 1.05, `stock` =`stock`+ 10
WHERE `product_id` = 'P05';

-- Cập nhật số điện thoại của khách hàng có customer_id = 'C03' thành '0999999999'.
UPDATE `customers`
SET `phone` = '0999999999'
WHERE `customer_id` = 'C03';

-- Xóa tất cả các bản ghi đơn hàng trong bảng Orders có trạng thái là 'Completed' và được đặt trước ngày '2025-10-03'.
DELETE FROM `orders`
WHERE `status` = 'Completed' AND `order_date` < '2025-10-03';

-- TRUY VẤN CƠ BẢN

-- Liệt kê các sản phẩm gồm product_id, product_name, price có giá bán từ 15,000,000 đến 30,000,000 và đang có stock > 0.
SELECT `product_id`, `product_name`, `price`
FROM `products`
WHERE `stock` > 0 AND `price` BETWEEN 15000000 AND 30000000;

-- Lấy thông tin full_name, email của những khách hàng có họ là 'Nguyễn'.
SELECT `full_name`, `email`
FROM `customers`
WHERE `full_name` LIKE 'Nguyễn %';

-- Hiển thị danh sách đơn hàng gồm order_id, customer_id, order_date. Sắp xếp theo order_date giảm dần.
SELECT `order_id`, `customer_id`, `order_date`
FROM `orders`
ORDER BY `order_date` DESC;

-- Lấy ra 3 sản phẩm có giá bán (price) đắt nhất trong cửa hàng.
SELECT * 
FROM `products`
ORDER BY `price` DESC
LIMIT 3;

-- Hiển thị danh sách product_name, stock từ bảng Products, bỏ qua 2 sản phẩm đầu tiên và lấy 2 sản phẩm tiếp theo (Phân trang).
SELECT `product_name`, `stock`
FROM `products`
LIMIT 2 OFFSET 2;

-- TRUY VẤN DỮ LIỆU NÂNG CAO
-- Hiển thị danh sách gồm: order_id, full_name (của khách hàng), product_name (của sản phẩm) và order_date. Chỉ lấy những đơn hàng đang có trạng thái 'Pending'.
SELECT O.`order_id`, C.`full_name` AS `Tên khách hàng`, P. `product_name` AS `Tên sản phẩm`, O.`order_date` AS `Ngày giao hàng`
FROM `orders` O
INNER JOIN `customers` C ON C. `customer_id` = O .`customer_id`
INNER JOIN `products` P ON P. `product_id` = O.`product_id`
WHERE O.`status` = 'Pending';

-- Liệt kê tất cả các Thương hiệu (Brand) và tên sản phẩm (product_name) thuộc thương hiệu đó. Hiển thị cả những thương hiệu chưa có sản phẩm nào
SELECT B.`brand_name`, P.`product_name`
FROM `brands` B
LEFT JOIN `products` P ON P.`brand_id` = B.`brand_id`
GROUP BY B.`brand_name`, P.`product_name`;

-- Tính tổng số đơn hàng theo từng trạng thái (status). Kết quả gồm hai cột: status và total_orders.
SELECT O.`status`, SUM(P.`price`) AS `total_orders`
FROM `orders` O
INNER JOIN `products` P ON P.`product_id` = O.`product_id`
GROUP BY  O.`status`;
-- Thống kê số lượng sản phẩm mà mỗi khách hàng đã đặt. Chỉ hiển thị tên khách hàng (full_name) có từ 2 đơn đặt hàng trở lên.
SELECT C.`full_name`, COUNT(O.`order_id`) AS `Số đơn hàng`
FROM `orders` O
INNER JOIN `customers` C ON C.`customer_id` = O .`customer_id`
GROUP BY C.`customer_id`,C.`full_name`
HAVING COUNT(O.`order_id`) >=2;

-- Lấy thông tin chi tiết các sản phẩm (product_id, product_name, price) có giá bán nhỏ hơn giá bán trung bình của tất cả các sản phẩm trong cửa hàng.
SELECT P.`product_id`, P.`product_name` , P.`price`
FROM `products` P 
WHERE P.`price` < (SELECT AVG(`price`) FROM `products`);

-- Hiển thị full_name và phone của những khách hàng đã từng đặt mua sản phẩm có tên là 'iPhone 15 Pro Max'.
SELECT `full_name`, `phone`
FROM `customers`
WHERE `customer_id` IN (SELECT `customer_id`
						FROM `orders`
                        WHERE `product_id` IN (SELECT `product_id`
											   FROM `products`
                                               WHERE `product_name` = 'iPhone 15 Pro Max'));
-- Hết 