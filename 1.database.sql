-- Desain Skema Database
CREATE TABLE
    keluarga (
        id INT AUTO_INCREMENT PRIMARY KEY,
        nama VARCHAR(50),
        jenis_kelamin ENUM ('Laki-laki', 'Perempuan'),
        id_orang_tua INT,
        FOREIGN KEY (id_orang_tua) REFERENCES keluarga (id)
    );

-- Data
INSERT INTO
    keluarga (nama, jenis_kelamin, id_orang_tua)
VALUES
    ('Yudi', 'Laki-laki', NULL), -- Root
    ('Fuad', 'Laki-laki', 1),
    ('Indah', 'Perempuan', 1),
    ('Faisal', 'Laki-laki', 1),
    ('Halim', 'Laki-laki', 1),
    ('Lisa', 'Perempuan', 2),
    ('Zikru', 'Laki-laki', 2),
    ('Iwe', 'Laki-laki', 3),
    ('Zaki', 'Laki-laki', 4),
    ('Nana', 'Perempuan', 4),
    ('Zainal', 'Laki-laki', 4),
    ('Rizal', 'Laki-laki', 5),
    ('Feri', 'Laki-laki', 7),
    ('Aida', 'Perempuan', 10),
    ('Lina', 'Perempuan', 11);

-- 1. Siapa saja anak Yudi yang hanya memiliki 1 anak
SELECT
    anak.nama,
    CONCAT (
        anak.nama,
        ' ',
        CASE
            WHEN anak.jenis_kelamin = 'Laki-laki' THEN 'bin'
            ELSE 'binti'
        END,
        ' ',
        orang_tua.nama
    ) AS nama_dengan_orangtua
FROM
    keluarga anak
    LEFT JOIN keluarga orang_tua ON anak.id_orang_tua = orang_tua.id
    LEFT JOIN keluarga cucu ON anak.id = cucu.id_orang_tua
WHERE
    orang_tua.nama = 'Yudi'
GROUP BY
    anak.id
HAVING
    COUNT(cucu.id) = 1;

-- 2. Siapa saja cucu Yudi yang perempuan dan siapa ayahnya
SELECT
    cucu.nama,
    CONCAT (cucu.nama, ' binti ', ayah.nama) AS nama_dengan_orangtua
FROM
    keluarga cucu
    JOIN keluarga ayah ON cucu.id_orang_tua = ayah.id
    JOIN keluarga kakek ON ayah.id_orang_tua = kakek.id
WHERE
    kakek.nama = 'Yudi'
    AND cucu.jenis_kelamin = 'Perempuan';

-- 3. Siapa saja cucu Yudi yang sudah memiliki anak
SELECT
    cucu.nama,
    CONCAT (
        cucu.nama,
        ' ',
        CASE
            WHEN cucu.jenis_kelamin = 'Laki-laki' THEN 'bin'
            ELSE 'binti'
        END,
        ' ',
        ayah.nama
    ) AS nama_dengan_orangtua
FROM
    keluarga cucu
    JOIN keluarga ayah ON cucu.id_orang_tua = ayah.id
    JOIN keluarga kakek ON ayah.id_orang_tua = kakek.id
WHERE
    kakek.nama = 'Yudi'
    AND EXISTS (
        SELECT
            1
        FROM
            keluarga anak
        WHERE
            anak.id_orang_tua = cucu.id
    );

-- 4. Siapa saja cicit Yudi yang sudah memiliki anak
SELECT
    cicit.nama,
    CONCAT (
        cicit.nama,
        ' ',
        CASE
            WHEN cicit.jenis_kelamin = 'Laki-laki' THEN 'bin'
            ELSE 'binti'
        END,
        ' ',
        orang_tua.nama
    ) AS nama_dengan_orangtua
FROM
    keluarga cicit
    JOIN keluarga orang_tua ON cicit.id_orang_tua = orang_tua.id
    JOIN keluarga kakek ON orang_tua.id_orang_tua = kakek.id
    JOIN keluarga buyut ON kakek.id_orang_tua = buyut.id
WHERE
    buyut.nama = 'Yudi'
    AND EXISTS (
        SELECT
            1
        FROM
            keluarga anak
        WHERE
            anak.id_orang_tua = cicit.id
    );

-- 5. Siapa saja sepupu dari Zaki
SELECT
    sepupu.nama,
    CONCAT (
        sepupu.nama,
        ' ',
        CASE
            WHEN sepupu.jenis_kelamin = 'Laki-laki' THEN 'bin'
            ELSE 'binti'
        END,
        ' ',
        orang_tua.nama
    ) AS nama_dengan_orangtua
FROM
    keluarga sepupu
    JOIN keluarga orang_tua ON sepupu.id_orang_tua = orang_tua.id
WHERE
    orang_tua.id_orang_tua != (
        SELECT
            id_orang_tua
        FROM
            keluarga
        WHERE
            nama = 'Zaki'
    );

-- 6. Siapa saja paman dan bibi dari Iwe
SELECT
    saudara.nama,
    CONCAT (
        saudara.nama,
        ' ',
        CASE
            WHEN saudara.jenis_kelamin = 'Laki-laki' THEN 'bin'
            ELSE 'binti'
        END,
        ' ',
        orang_tua.nama
    ) AS nama_dengan_orangtua
FROM
    keluarga saudara
    JOIN keluarga orang_tua ON saudara.id_orang_tua = orang_tua.id
WHERE
    orang_tua.nama = (
        SELECT
            nama
        FROM
            keluarga
        WHERE
            id = (
                SELECT
                    id_orang_tua
                FROM
                    keluarga
                WHERE
                    nama = 'Iwe'
            )
    )
    AND saudara.nama != 'Iwe';

-- 7. Siapa saja sepupu dari kakeknya Feri
SELECT
    sepupu.nama,
    CONCAT (
        sepupu.nama,
        ' ',
        CASE
            WHEN sepupu.jenis_kelamin = 'Laki-laki' THEN 'bin'
            ELSE 'binti'
        END,
        ' ',
        orang_tua.nama
    ) AS nama_dengan_orangtua
FROM
    keluarga sepupu
    JOIN keluarga orang_tua ON sepupu.id_orang_tua = orang_tua.id
WHERE
    orang_tua.id_orang_tua = (
        SELECT
            id_orang_tua
        FROM
            keluarga
        WHERE
            id = (
                SELECT
                    id_orang_tua
                FROM
                    keluarga
                WHERE
                    nama = 'Feri'
            )
    );

-- 8 Siapa saja cucu dari FuadSELECT cucu.nama, 
SELECT
    cucu.nama,
    CONCAT (
        cucu.nama,
        ' ',
        CASE
            WHEN cucu.jenis_kelamin = 'Laki-laki' THEN 'bin'
            ELSE 'binti'
        END,
        ' ',
        ayah.nama
    ) AS nama_dengan_orangtua
FROM
    keluarga cucu
    JOIN keluarga ayah ON cucu.id_orang_tua = ayah.id
WHERE
    ayah.id_orang_tua = (
        SELECT
            id
        FROM
            keluarga
        WHERE
            nama = 'Fuad'
    );

-- 9.Siapa saja anak dari Zaki
SELECT
    anak.nama,
    CONCAT (
        anak.nama,
        ' ',
        CASE
            WHEN anak.jenis_kelamin = 'Laki-laki' THEN 'bin'
            ELSE 'binti'
        END,
        ' ',
        orang_tua.nama
    ) AS nama_dengan_orangtua
FROM
    keluarga anak
    JOIN keluarga orang_tua ON anak.id_orang_tua = orang_tua.id
WHERE
    orang_tua.nama = 'Zaki';

-- 10. Siapa saja anak dari Aida
SELECT
    anak.nama,
    CONCAT (
        anak.nama,
        ' ',
        CASE
            WHEN anak.jenis_kelamin = 'Laki-laki' THEN 'bin'
            ELSE 'binti'
        END,
        ' ',
        orang_tua.nama
    ) AS nama_dengan_orangtua
FROM
    keluarga anak
    JOIN keluarga orang_tua ON anak.id_orang_tua = orang_tua.id
WHERE
    orang_tua.nama = 'Aida';