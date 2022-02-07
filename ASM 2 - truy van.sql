USE asm2
GO

-- Tạo index cho bảng BinhLuan để tăng tốc độ tìm email tương ứng với tên người bình luận
CREATE INDEX idx_BinhLuan_Name
ON BinhLuan(TenNguoiBL)
GO

-- Tạo trigger để khi một khách bình luận thì nếu người đó không nhập đủ email và tên thì hủy bỏ thao tác bổ sung

CREATE TRIGGER TG_BINHLUAN_KHACH
ON BinhLuan
AFTER INSERT
AS
BEGIN
	DECLARE @idUser INT
	DECLARE @Email varchar(255)
	DECLARE @Ten NVARCHAR(128)
	SELECT @idUser = idUser, @Email = EmailBL, @Ten = TenNguoiBL FROM inserted
	IF @idUser IS NULL
		BEGIN
			IF (@Email IS NULL) OR (@Ten IS NULL)
			ROLLBACK TRAN
		END
END

insert into BinhLuan(NoiDungBL, TenNguoiBL, EmailBL, idBaiBao, idUser)
values
	('That sao', 'ThuyHan', DEFAULT, 1, DEFAULT)
SELECT * FROM BinhLuan
GO
-- Tạo một SP có đầu vào là idChuDe, xác định xem chủ đề này có bao nhiêu bài báo, kết quả trả về trong một tham số kiểu output

CREATE PROC USP_SOBAIBAO
	(@idchude SMALLINT,
	@sobaibao INT OUTPUT)
AS
BEGIN 
	SELECT @sobaibao = COUNT(*)
	FROM BaiBao, ChuDe
	WHERE BaiBao.idChuDe = ChuDe.idChuDe
	AND BaiBao.idChuDe = @idchude
END
GO

DECLARE @sobaibao int 
EXEC USP_SOBAIBAO 2, @sobaibao OUTPUT
SELECT @sobaibao AS 'Sobaibao'
GO
-- Tạo một function xác định xem top 2 bài báo có nhiều bình luận nhất

CREATE OR ALTER FUNCTION FC_TOPBAIBAO
()
RETURNS TABLE AS RETURN
(	
	--WITH SELECT idBaiBao
	SELECT * FROM (
		SELECT BaiBao.idBaiBao, COUNT(BaiBao.idBaiBao) AS SoBinhLuan, DENSE_RANK() OVER(ORDER BY COUNT(BaiBao.idBaiBao) DESC) AS ThuTu
		FROM BaiBao, BinhLuan
		WHERE BaiBao.idBaiBao = BinhLuan.idBaiBao
		GROUP BY BaiBao.idBaiBao) as t
	WHERE ThuTu <= 2
)
GO

SELECT * FROM FC_TOPBAIBAO()

-- Tạo một transaction thực hiện nhập dữ liệu vào cả 2 bảng BinhChon và PhuongAn cùng lúc. Nếu có một vấn đề trong 
-- quá trình chèn dữ liệu thì hủy bỏ hoàn toàn quá trình trên
--cach 1
BEGIN TRANSACTION
BEGIN TRY
	INSERT INTO BinhChon(MoTaBinhChon, idBaiBao)
	VALUES
		(N'Kết quả trận Việt Nam - UAE ngày 15/6?', 2);

	INSERT INTO PhuongAn(NoiDungPA, idBinhChon)
	VALUES
		(N'Việt Nam thắng',41),
		(N'Hòa', 4), 
		(N'UAE thắng', 4);
	COMMIT TRAN
END TRY
BEGIN CATCH
        ROLLBACK TRANSACTION
END CATCH
SELECT * FROM BinhChon
SELECT * FROM PhuongAn

--cach 2
SET XACT_ABORT ON;
GO
BEGIN TRANSACTION
	INSERT INTO BinhChon(MoTaBinhChon, idBaiBao)
	VALUES
		(N'Kết quả trận Việt Nam - UAE ngày 15/6?', 1);

	INSERT INTO PhuongAn(NoiDungPA, idBinhChon)
	VALUES
		(N'Việt Nam thắng',4),
		(N'Hòa', 4), 
		(N'UAE thắng', 4);
COMMIT TRANSACTION
GO
SET XACT_ABORT OFF
SELECT * FROM BinhChon
SELECT * FROM PhuongAn



--Truy vấn dữ liệu trên một bảng
SELECT * FROM ThanhVien;

--Truy vấn có sử dụng Order by
SELECT UserName, NgaySinh
FROM ThanhVien
WHERE NgaySinh IS NOT NULL
ORDER BY NgaySinh;

--Truy vấn dữ liệu từ nhiều bảng sử dụng Inner join
SELECT UserName, Email, idBaiBao, TieuDe
FROM ThanhVien INNER JOIN BaiBao
ON ThanhVien.idUser = BaiBao.TacGia;

--Truy vấn thống kê sử dụng Group by và Having
SELECT TacGia, UserName, COUNT(*) AS SoBaiBao
FROM ThanhVien, BaiBao
WHERE ThanhVien.idUser = BaiBao.TacGia
GROUP BY TacGia, UserName
HAVING COUNT(*) >= ALL (SELECT COUNT(*) 
						FROM ThanhVien, BaiBao
						WHERE ThanhVien.idUser = BaiBao.TacGia 
						GROUP BY TacGia);

-- Truy vấn sử dụng toán tử Like 
SELECT COUNT(*) as SoLuongDungGmail
FROM ThanhVien
WHERE Email LIKE '%@gmail%'

-- Truy vấn sử dụng các so sánh xâu ký tự.
SELECT UserName, Ten, Ho, Email
FROM ThanhVien
WHERE VaiTro = 'phongvien'

-- Truy vấn sử dụng With.
WITH CTE AS (SELECT ChuDe.idChuDe, COUNT(*) AS number
			FROM BaiBao, ChuDe 
			WHERE BAIBAO.idChuDe = ChuDe.idChuDe
			GROUP BY ChuDe.idChuDe)
SELECT TenChuDe
FROM ChuDe, BaiBao
WHERE ChuDe.idChuDe = BaiBao.idChuDe
GROUP BY TenChuDe
HAVING count(*) = (SELECT MAX(number) FROM CTE)


-- Truy vấn sử dụng function (hàm) đã viết trong bước trước.
SELECT TieuDe
FROM FC_TOPBAIBAO() AS T CROSS APPLY BaiBao
WHERE BaiBao.idBaiBao = T.idBaiBao
AND T.ThuTu = 1

--	Truy vấn sử dụng union
SELECT EmailBL
FROM BinhLuan
UNION
SELECT Email
FROM ThanhVien

-- Truy vấn liên quan tới điều kiện về thời gian
SELECT UserName, Ho, Ten, Email, NgaySinh
FROM ThanhVien
WHERE NgaySinh > '2000-01-01'