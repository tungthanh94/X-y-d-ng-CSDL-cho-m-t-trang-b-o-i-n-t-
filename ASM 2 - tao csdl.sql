CREATE DATABASE asm2
GO

USE asm2
GO

CREATE TABLE TheLoai(
	idTheLoai TINYINT IDENTITY(1,1) CONSTRAINT PK_THELOAI PRIMARY KEY,
	TenTheLoai NVARCHAR(255) NOT NULL,
	AnHien BIT DEFAULT 1 NOT NULL);

CREATE TABLE ThanhVien(
	idUser INT IDENTITY(1,1) CONSTRAINT PK_THANHVIEN PRIMARY KEY,
	VaiTro VARCHAR(20) DEFAULT 'docgia' NOT NULL,
	UserName NVARCHAR(50) NOT NULL,
	Ten NVARCHAR(50) NOT NULL,
	Ho NVARCHAR(128) NOT NULL,
	Email VARCHAR(255) UNIQUE NOT NULL,
	MatKhau CHAR(8),
	DienThoai VARCHAR(20) NULL,
	DiaChi NVARCHAR(255) NULL,
	NgaySinh DATE NULL,
	GioiTinh BIT NULL,
	NgayDangKy DATETIME DEFAULT GETDATE() NOT NULL,
	Active BIT DEFAULT 1 NOT NULL,
	GhiChu NVARCHAR(255) NULL,
	CONSTRAINT chkNgaySinh CHECK (NgaySinh < NgayDangKy),
	CONSTRAINT chkVaiTro CHECK (VaiTro in ('docgia', 'phongvien', 'bientapvien')),
	CONSTRAINT chkMatKhau CHECK (LEN(MatKhau) = 8));

CREATE TABLE BaiBao(
	idBaiBao INT IDENTITY(1,1) CONSTRAINT PK_BAIBAO PRIMARY KEY,
	TieuDe NVARCHAR(255) NOT NULL,
	TomTat NVARCHAR(500) NOT NULL,
	urlAvartar NVARCHAR(255) NOT NULL,
	NoiDungBB NVARCHAR(MAX) NOT NULL,
	urlHinhAnh NVARCHAR(255) NULL,
	ThoiGianDang DATETIME NULL,
	AnHien BIT DEFAULT 0 NOT NULL,
	idChuDe SMALLINT NOT NULL,
	TacGia INT NOT NULL,
	NguoiDuyet INT NULL);

CREATE TABLE BinhLuan(
	idBinhLuan INT IDENTITY(1,1) CONSTRAINT PK_BINHLUAN PRIMARY KEY,
	NoiDungBL NVARCHAR(1500) NOT NULL,
	TenNguoiBL NVARCHAR(128) NULL,
	EmailBL VARCHAR(255) NULL,
	ThoiGianBL DATETIME DEFAULT GETDATE() NOT NULL,
	AnHien BIT DEFAULT 1 NOT NULL,
	BinhLuanCha int NULL CONSTRAINT FK_BINHLUAN_BINHLUAN FOREIGN KEY REFERENCES BINHLUAN(idBinhLuan),
	idBaiBao INT NOT NULL CONSTRAINT FK_BINHLUAN_BAIBAO FOREIGN KEY REFERENCES BaiBao(idBaiBao),
	idUser INT NULL CONSTRAINT FK_BINHLUAN_THANHVIEN FOREIGN KEY REFERENCES ThanhVien(idUser));

CREATE TABLE BinhChon(
	idBinhChon INT IDENTITY(1,1) CONSTRAINT PK_BINHCHON PRIMARY KEY,
	MoTaBinhChon NVARCHAR(500) NOT NULL,
	AnHien BIT DEFAULT 1 NOT NULL,
	idBaiBao INT NOT NULL CONSTRAINT FK_BINHCHON_BAIBAO FOREIGN KEY REFERENCES BaiBao(idBaiBao));

CREATE TABLE PhuongAn(
	idPhuongAn INT IDENTITY(1,1) CONSTRAINT PK_PHUONGAN PRIMARY KEY,
	NoiDungPA NVARCHAR(500) NOT NULL,
	SoLanChon INT DEFAULT 0 NOT NULL,
	AnHien BIT DEFAULT 1 NOT NULL,
	idBinhChon INT NOT NULL CONSTRAINT FK_PHUONGAN_BINHCHON FOREIGN KEY REFERENCES BinhChon(idBinhChon));

CREATE TABLE ChuDe(
	idChuDe SMALLINT IDENTITY(1,1) CONSTRAINT PK_CHUDE PRIMARY KEY,
	TenChuDe NVARCHAR(255) NOT NULL,
	AnHien BIT DEFAULT 1 NOT NULL,
	idTheLoai TINYINT NOT NULL CONSTRAINT FK_CHUDE_THELOAI FOREIGN KEY REFERENCES TheLoai(idTheLoai));

ALTER TABLE BaiBao
ADD CONSTRAINT FK_BAIBAO_CHUDE FOREIGN KEY (idChuDe) REFERENCES ChuDe(idChuDe),
	CONSTRAINT FK_BAIBA0_TACGIA FOREIGN KEY (TacGia) REFERENCES ThanhVien(idUser),
	CONSTRAINT FK_BAIBAO_NGUOIDUYET FOREIGN KEY (NguoiDuyet) REFERENCES ThanhVien(idUser);


INSERT INTO TheLoai(TenTheLoai)
VALUES
	(N'Xã hội'),
	(N'Khoa học'),
	(N'Thế giới'),
	(N'Thể thao'),
	(N'Sức khỏe'),
	(N'Du lịch'),
	(N'Kinh doanh'),
	(N'Giáo dục'),
	(N'Pháp luật');

INSERT INTO ChuDe(TenChuDe, idTheLoai)
VALUES
	(N'Chính trị', 1),
	(N'Giao thông', 1),
	(N'Phát minh', 2),
	(N'Thế giới tự nhiên', 2),
	(N'Công nghệ', 3),
	(N'Châu Á', 3),
	(N'Châu Mỹ', 3),
	(N'Bóng đá trong nước', 4),
	(N'Bóng đá châu Âu', 4),
	(N'Dinh dưỡng', 5),
	(N'Điểm đến', 6),
	(N'Chứng khoán', 7),
	(N'Tuyển sinh', 7),
	(N'Tư vấn pháp luật', 8);

INSERT INTO ThanhVien(VaiTro, UserName, Ten, Ho, MatKhau, Email, DienThoai, DiaChi, NgaySinh, GioiTinh, Active)
VALUES
	(DEFAULT, 'thanhtuan', 'Tuan', 'Nguyen Thanh', '12345678', 'tuannt12@gmail.com', DEFAULT, DEFAULT, '1990-02-12',0,1),
	('phongvien', 'tuananh', 'Anh', 'Phan Tuan', '12312312', 'Anhpt@gmail.com', '0988188188', 'Quan 10', '1972-06-12', 0, 1),
	('bientapvien', 'maitrang', 'Trang', 'Nguyen Mai', '2569871h', 'Trangnm@gmail.com', '0979199199', 'Quan 1', '1976-09-15', 1, 1),
	(DEFAULT, 'NgocHoang', 'Hoang', 'Phan Ngoc', '214fgb54', 'hoangpn@outlook.com', DEFAULT,DEFAULT,DEFAULT, 0, 1),
	(DEFAULT, 'Thien', 'Thien', 'Nguyen Thuan', 'gbdc154s', 'thiennt@yahoo.com', DEFAULT,DEFAULT,DEFAULT,0,0),
	(DEFAULT, 'Quynh', 'Quynh', 'Mai Van', '41bgdhyg', 'Quynhmv@gmail.com', DEFAULT, DEFAULT, '1946-03-21',0,1),
	(DEFAULT, 'Diem', 'Diem', 'Nguyen Thi', 'fghdubc7', 'diemnt@gmail.com', '0169452452', 'Quan 8', '2007-10-25',1,1),
	('phongvien', 'NganGL', 'Ngan', 'Nguyen Thai', '451vfd21', 'ngannt@gmail.com', '0245412412', 'Quan 4', '2001-06-01',1,1),
	(DEFAULT, 'Cuong', 'Cuong', 'Tran Dinh', '12458745', 'cuongtd@gmail.com', DEFAULT, 'Gia lai', DEFAULT, 0, 1),
	(DEFAULT, 'PhuongSG', 'Phuong', 'Truc', '124gng15', 'phuongt@outlook.com', DEFAULT,DEFAULT,DEFAULT,1,1),
	(DEFAULT, 'ThaoMai', 'Thao', 'Dang Thi', 'hgybhgdf', 'thaodt@gmail.com', DEFAULT,DEFAULT,DEFAULT,1,1);
	
INSERT INTO BaiBao(TieuDe, TomTat, NoiDungBB, urlAvartar, AnHien, ThoiGianDang, idChuDe, TacGia, NguoiDuyet)
VALUES
	(N'Gỡ vướng nguồn vật liệu xây dựng cao tốc Bắc Nam',
	N'Chính phủ cho phép các tỉnh áp dụng cơ chế đặc thù trong khai thác khoáng sản, vật liệu để cung cấp cho các đơn vị xây dựng cao tốc Bắc Nam.',
	N'Theo nghị quyết của Chính phủ ngày 16/6, các tỉnh có tuyến cao tốc Bắc Nam đi qua được phép phê duyệt khai thác mỏ vật liệu như đất, đá đã có trong quy hoạch mà không phải qua đấu giá quyền khai thác. Các mỏ đang khai thác được nâng công suất đến 50% mà không phải lập dự án điều chỉnh, đánh giá tác động môi trường.',
	'https://i1-vnexpress.vnecdn.net/2021/06/16/mai-son-9343-1613874812-6566-1623842149.jpg?w=0&h=0&q=100&dpr=2&fit=crop&s=oPpe9PdOr_AQ51Md4CrSNg',
	1,
	DEFAULT,
	2,
	2,
	3),
	(N'Việt Nam và bài học đáng giá từ trận thua UAE',
	N'Trận đấu UAE hôm 15/6 gợi mở về thách thức mà Việt Nam sẽ gặp ở vòng loại cuối World Cup, nhưng đồng thời cho thấy tấm vé lịch sử không phải là một chiếc áo quá rộng.',
	'Vị trí nhì bảng và một tấm vé vào vòng loại cuối cùng không phải là một kết quả nằm ngoài dự báo. Đó là mục tiêu cụ thể mà Việt Nam đã đặt ra khi biết kết quả bốc thăm, và rơi vào bảng đấu "tử thần". Tại bảng G, UAE vẫn được đánh giá cao nhất và họ cũng đã thể hiện được sức m',
	'https://i1-vnexpress.vnecdn.net/2021/06/16/199911498-364752718551987-6361-6742-8972-1623819822.jpg?w=680&h=0&q=100&dpr=1&fit=crop&s=KyV2e90rtTCLDFtu7YkwLg',
	0, 
	'2021-06-18',
	8,
	8,
	3),
	(N'Việt Nam - UAE: Thuốc thử liều cao',
	N'Nếu như ví vòng loại cuối cùng World Cup là "biển lớn", trận đấu với đối thủ mạnh như UAE tối 15/6 có thể giúp Việt Nam kiểm chứng sức mạnh và tham vọng của bản thân.',
	N'UAE từng thua Việt Nam ở Mỹ Đình tháng 11/2019, nhưng vẫn thuộc nhóm đội mạnh thứ hai châu Á, chỉ sau những khách quen World Cup như Nhật Bản, Hàn Quốc, Iran hay Australia. Cuộc tái ngộ ',
	'https://i1-vnexpress.vnecdn.net/2021/06/14/vietnam-jpeg-1623660155-162366-9307-1668-1623660394.jpg?w=680&h=0&q=100&dpr=1&fit=crop&s=Fs7Gcy1XDR_BTXBIKubIqg',
	1,
	DEFAULT,
	8,
	8,
	3),
	(N'Hổ vượt rào vồ chết nhân viên vườn thú',
	N'Con hổ Siberia tên Jasper giết chết nhân viên ở vườn thú Seaview Predator Park tại Gqeberha chiều hôm 16/6 khi nạn nhân đang sửa hàng rào điện của chuồng.',
	N'David Siphiwo Solomon làm việc trong chuồng nuôi Jasper và một con hổ Siberia khác tên Jade. Theo thông báo hôm 17/6 của vườn thú, Solomon bị con hổ tấn công trong lúc ở lối đi giữa hai khu chuồng và đang đi bộ về phía vòi nước. Anh cố gắng chạy trốn bằng cách trèo lên hàng rào của một ',
	'https://i1-vnexpress.vnecdn.net/2021/06/18/VNE-Tiger-3088-1623987361.jpg?w=680&h=0&q=100&dpr=1&fit=crop&s=Dqpc7aUuTDAbtQjhHuXRuw',
	1,
	DEFAULT,
	4, 
	2,
	DEFAULT);

INSERT INTO BinhChon(MoTaBinhChon, idBaiBao)
VALUES
	(N'Kết quả trận Việt Nam - UAE ngày 15/6?', 3);

INSERT INTO PhuongAn(NoiDungPA, idBinhChon)
VALUES
	(N'Việt Nam thắng', 1),
	(N'Hòa', 1), 
	(N'UAE thắng', 1);

INSERT INTO BinhLuan(EmailBL, TenNguoiBL, NoiDungBL, idBaiBao)
VALUES
	('phuongtv@gmail.com', 'phuongvodich', N'Thật luôn!', 1),
	('minhtrandang@gmail.com', 'minhtran', N'Chúng ta', 1),
	('huynq@gmail.com', 'huyhuy', N'Đúng vậy', 2),
	('baopv@gmail.com', 'baogl', N'Việt Nam Vô địch!', 2),
	('ngocnt@outlook.com', 'ngocngo', N'Cũng được', 2),
	('thiennn@gmail.com', 'thientai', N'Lần sau', 2);


