USE [master]
GO
/****** Object:  Database [bazaMusic]    Script Date: 07.10.2024 23:25:30 ******/
CREATE DATABASE [bazaMusic]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'bazaMusic_Data', FILENAME = N'c:\dzsqls\bazaMusic.mdf' , SIZE = 8192KB , MAXSIZE = 30720KB , FILEGROWTH = 22528KB )
 LOG ON 
( NAME = N'bazaMusic_Logs', FILENAME = N'c:\dzsqls\bazaMusic.ldf' , SIZE = 8192KB , MAXSIZE = 30720KB , FILEGROWTH = 22528KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [bazaMusic] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [bazaMusic].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [bazaMusic] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [bazaMusic] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [bazaMusic] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [bazaMusic] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [bazaMusic] SET ARITHABORT OFF 
GO
ALTER DATABASE [bazaMusic] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [bazaMusic] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [bazaMusic] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [bazaMusic] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [bazaMusic] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [bazaMusic] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [bazaMusic] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [bazaMusic] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [bazaMusic] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [bazaMusic] SET  ENABLE_BROKER 
GO
ALTER DATABASE [bazaMusic] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [bazaMusic] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [bazaMusic] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [bazaMusic] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [bazaMusic] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [bazaMusic] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [bazaMusic] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [bazaMusic] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [bazaMusic] SET  MULTI_USER 
GO
ALTER DATABASE [bazaMusic] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [bazaMusic] SET DB_CHAINING OFF 
GO
ALTER DATABASE [bazaMusic] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [bazaMusic] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [bazaMusic] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [bazaMusic] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [bazaMusic] SET QUERY_STORE = OFF
GO
USE [bazaMusic]
GO
/****** Object:  User [becia99_SQLLogin_1]    Script Date: 07.10.2024 23:25:32 ******/
CREATE USER [becia99_SQLLogin_1] FOR LOGIN [becia99_SQLLogin_1] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [becia99_SQLLogin_1]
GO
/****** Object:  Schema [becia99_SQLLogin_1]    Script Date: 07.10.2024 23:25:33 ******/
CREATE SCHEMA [becia99_SQLLogin_1]
GO
/****** Object:  Table [dbo].[__EFMigrationsHistory]    Script Date: 07.10.2024 23:25:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[__EFMigrationsHistory](
	[MigrationId] [nvarchar](150) NOT NULL,
	[ProductVersion] [nvarchar](32) NOT NULL,
 CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY CLUSTERED 
(
	[MigrationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Albums]    Script Date: 07.10.2024 23:25:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Albums](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](max) NULL,
	[PublishDate] [int] NULL,
	[Poster] [nvarchar](max) NULL,
	[TypeId] [int] NOT NULL,
	[ArtistId] [int] NULL,
	[CategoryId] [int] NULL,
	[Date] [nvarchar](max) NULL,
 CONSTRAINT [PK_Albums] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ArtistAlbums]    Script Date: 07.10.2024 23:25:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ArtistAlbums](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ArtistId] [int] NOT NULL,
	[AlbumId] [int] NOT NULL,
 CONSTRAINT [PK_ArtistAlbum] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Artists]    Script Date: 07.10.2024 23:25:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Artists](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
 CONSTRAINT [PK_Artists] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Categories]    Script Date: 07.10.2024 23:25:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Categories](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_Categories] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Songs]    Script Date: 07.10.2024 23:25:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Songs](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Number] [int] NOT NULL,
	[AlbumId] [int] NOT NULL,
 CONSTRAINT [PK_Songs] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Types]    Script Date: 07.10.2024 23:25:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Types](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
 CONSTRAINT [PK_Types] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'20240303222323_nowa', N'5.0.17')
GO
SET IDENTITY_INSERT [dbo].[Albums] ON 

INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (14, N'Brain Dead Family', 2015, N'/posters/14_brain_dead_family_cd.jpg', 1, 8, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (15, N'CzarNaKrew', 2015, N'/posters/15_czarnakrew_cd.jpg', 1, 9, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (16, N'Czarne Światło', 2015, N'/posters/16_czarne_wiato_cd.jpg', 1, 10, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (17, N'Redrum', 2020, N'/posters/Redrum_CD.jpg', 1, 8, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (18, N'Shotgun', 2015, N'/posters/Shotgun_CD.jpg', 1, 12, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (19, N'Unhuman Mixtape', 2009, N'/posters/19_unhuman_mixtape_cd.jpg', 1, 13, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (20, N'Szkoła Wyrzutków', 2012, N'/posters/Szkoła Wyrzutków_CD.jpg', 1, 13, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (21, N'Oko', 2015, N'/posters/Oko_CD.jpg', 1, 9, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (22, N'Mam się świetnie', 2016, N'/posters/Mam się świetnie_CD.jpg', 1, 16, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (23, N'PDG Gawrosz', 2011, N'/posters/PDG Gawrosz_CD.jpg', 1, 16, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (24, N'Chore melodie', 2009, N'/posters/Chore melodie_CD.jpg', 1, 8, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (25, N'Fopa i Nietakt', 2016, N'/posters/Fopa i Nietakt_CD.jpg', 1, 13, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (26, N'Wojtek Sokół', 2019, N'/posters/26_wojtek_sokol_lp.jpg', 2, 17, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (27, N'Redrum', 2020, N'/posters/Redrum_LP.jpg', 2, 8, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (28, N'Mutylator', 2018, N'/posters/Mutylator_LP.jpg', 2, 8, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (29, N'Brain Dead Familia', 2015, N'/posters/Brain Dead Familia_LP.jpg', 2, 8, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (30, N'Demonologia', 2010, N'/posters/Demonologia_CD.jpg', 1, 8, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (31, N'Demonologia II', 2013, N'/posters/Demonologia II_CD.jpg', 1, 8, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (32, N'Chore Melodie', 2009, N'/posters/Chore Melodie_LP.jpg', 2, 8, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (33, N'Cock.0z Mixtape', 2021, N'/posters/Cock.0z Mixtape_CD.jpg', 1, 18, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (34, N'Książę Nieporządek', 2018, N'/posters/Książę Nieporządek_CD.jpg', 1, 18, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (35, N'Digital Scale Music', 2020, N'/posters/Digital Scale Music_CD.jpg', 1, 18, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (36, N'Nielegal 216', 2016, N'/posters/Nielegal 216_CD.jpg', 1, 19, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (37, N'Nielegal 215', 2015, N'/posters/Nielegal 215_CD.jpg', 1, 19, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (38, N'Takie rzeczy', 2013, N'/posters/Takie rzeczy_CD.jpg', 1, 20, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (39, N'Trzecie Rzeczy', 2016, N'/posters/39_trzecie_rzeczy_cd.jpg', 1, 20, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (40, N'Mr KęKę', 2019, N'/posters/Mr KęKę_CD.jpg', 1, 20, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (41, N'Nowe rzeczy', 2015, N'/posters/Nowe rzeczy_CD.jpg', 1, 20, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (42, N'Uhqqow', 2018, N'/posters/42_uhqqow_cd.jpg', 1, 21, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (43, N'Nielegal 217', 2017, N'/posters/Nielegal 217_CD.jpg', 1, 19, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (44, N'ANtY', 2018, N'/posters/ANtY_CD.jpg', 1, 19, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (45, N'Sygnatura Akt. BRS 2019', 2019, N'/posters/Sygnatura Akt. BRS 2019_CD.jpg', 1, 22, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (46, N'Chleb i Miód', 2018, N'/posters/Chleb i Miód_CD.jpg', 1, 18, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (47, N'Polska Gotówkowa', 2019, N'/posters/Polska Gotówkowa_CD.jpg', 1, 18, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (48, N'Narkopop', 2017, N'/posters/Narkopop_CD.jpg', 1, 18, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (49, N'Narkopop Wave', 2021, N'/posters/Narkopop Wave_CD.jpg', 1, 18, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (50, N'Akademia Sztuk Pięknych', 2021, N'/posters/Akademia Sztuk Pięknych_CD.jpg', 1, 23, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (51, N'Akademia Sztuk Pięknych EP', 2021, N'/posters/Akademia Sztuk Pięknych EP_CD.jpg', 1, 23, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (52, N'Powrót z drogi donikąd', 2021, N'/posters/Powrót z drogi donikąd_CD.jpg', 1, 24, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (53, N'Moje Melancholie', 2022, N'/posters/Moje Melancholie_CD.jpg', 1, 25, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (56, N'Kodex (Reedycja)', 2002, N'/posters/Kodex (Reedycja)_CD.jpg', 1, 26, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (57, N'Kodex (oryginał)', 2002, N'/posters/Kodex (oryginał)_CD.jpg', 1, 26, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (58, N'Odmienny stan świadomości', 2015, N'/posters/Odmienny stan świadomości_CD.jpg', 1, 27, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (59, N'Człowiek duch', 2016, N'/posters/Człowiek duch_CD.jpg', 1, 28, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (60, N'I niech szukają mnie kule', 2013, N'/posters/I niech szukają mnie kule_CD.jpg', 1, 28, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (61, N'21 gramów', 2011, N'/posters/21 gramów_CD.jpg', 1, 28, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (62, N'Eksperyment', 2017, N'/posters/Eksperyment_CD.jpg', 1, 29, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (63, N'Łajzol Serious', 2022, N'/posters/63_lajzol_serious_cd.jpg', 1, 30, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (65, N'Kodex 2: Proces', 2004, N'/posters/Kodex 2 Proces_CD.jpg', 1, 26, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (66, N'Kodex 3: Wyrok', 2007, N'/posters/Kodex 3 Wyrok_CD.jpg', 1, 26, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (67, N'Książę aka. Slumilioner', 2014, N'/posters/Książę aka. Slumilioner_CD.jpg', 1, 31, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (68, N'Teraz pieniądz w cenie', 2007, N'/posters/Teraz pieniądz w cenie_CD.jpg', 1, 32, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (69, N'Ty przecież wiesz co', 2008, N'/posters/69_ty_przeciez_wiesz_co_cd.jpg', 1, 32, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (70, N'Nic', 2021, N'/posters/Nic_CD.jpg', 1, 17, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (71, N'Wojtek Sokół', 2019, N'/posters/71_wojtek_sokol_cd.jpg', 1, 17, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (72, N'Życie na kredycie', 2005, N'/posters/72_ycie_na_kredycie_cd.jpg', 1, 33, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (73, N'Chleb powszedni', 1999, N'/posters/Chleb powszedni_CD.jpg', 1, 34, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (74, N'We własnej osobie', 2002, N'/posters/74_we_wlasnej_osobie_cd.jpg', 1, 33, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (75, N'Czysta brudna prawda', 2011, N'/posters/Czysta brudna prawda_CD.jpg', 1, 17, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (76, N'Czarna biała magia', 2013, N'/posters/Czarna biała magia_CD.jpg', 1, 17, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (77, N'Logika gry', 2011, N'/posters/Logika gry_CD.jpg', 1, 35, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (78, N'No Way Out', 1997, N'/posters/No Way Out_CD.jpg', 1, 36, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (79, N'Na otwartym sercu', 2022, N'/posters/Na otwartym sercu_CD.jpg', 1, 37, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (81, N'Panaceum 3: Czarno na białym', 2020, N'/posters/Panaceum 3 Czarno na białym_CD.jpg', 1, 37, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (82, N'Panaceum 2: Trzeba Żyć', 2017, N'/posters/Panaceum 2 Trzeba Żyć_CD.jpg', 1, 37, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (83, N'Panaceum', 2014, N'/posters/Panaceum_CD.jpg', 1, 37, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (84, N'Dwa Światy vol. 2', 2019, N'/posters/Dwa światy_CD.jpg', 1, 38, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (85, N'Dwa Światy vol. 1', 2019, N'/posters/Dwa Światy vol.1_CD.jpg', 1, 38, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (86, N'Mały książę', 2023, N'/posters/Mały książę_CD.jpg', 1, 39, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (87, N'B&B Warsaw', 2023, N'/posters/B&B Warsaw_CD.jpg', 1, 18, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (88, N'Progres 2', 2016, N'/posters/Progres 56_CD.jpg', 1, 38, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (89, N'NO LIMIT', 2022, N'/posters/NO LIMIT_CD.jpg', 1, 38, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (90, N'Kwiaty zła', 2008, N'/posters/Kwiaty zła_CD.jpg', 1, 40, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (91, N'Trinity', 2021, N'/posters/91_trinity_tape.jpg', 3, 16, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (92, N'To co najlepsze z dziesięciu lat (1983–93)', 1993, N'/posters/92_to_co_najlepsze_z_dziesieciu_lat_1983–93_lp.jpg', 2, 41, 3, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (93, N'Memento Mori', 2023, N'/posters/Memento Mori_LP.jpg', 2, 42, 2, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (94, N'Violator', 1990, N'/posters/94_violator_lp.jpg', 2, 42, 2, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (95, N'DMX The Legacy', 2021, N'/posters/DMX The Legacy_LP.jpg', 2, 43, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (96, N'The Great Depression', 2001, N'/posters/The Great Depression_LP.jpg', 2, 43, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (98, N'...And Then There Was X', 1999, N'/posters/And Then There Was X_LP.jpg', 2, 43, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (99, N'2001', 1999, N'/posters/2001_LP.jpg', 2, 44, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (100, N'The Chronic', 1992, N'/posters/The Chronic_LP.jpg', 2, 44, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (101, N'Hold It Down', 1995, N'/posters/Hold It Down_LP.jpg', 2, 45, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (102, N'Straight Up Sewaside', 1993, N'/posters/Straight Up Sewaside_LP.jpg', 2, 45, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (103, N'Dead Serious', 1992, N'/posters/Dead Serious_LP.jpg', 2, 45, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (104, N'Gangsta''s Paradise', 1995, N'/posters/Gangstas Paradise_LP.jpg', 2, 46, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (105, N'Bal wszystkich świętych', 2000, N'/posters/Bal wszystkich świętych_LP.jpg', 2, 47, 2, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (106, N'Life After Death', 1997, N'/posters/Life After Death_LP.jpg', 2, 48, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (107, N'Ready to Die', 1994, N'/posters/Ready to Die_LP.jpg', 2, 48, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (108, N'13', 2013, N'/posters/108_13_lp.jpg', 2, 49, 2, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (109, N'Kręci mnie vinyl', 2011, N'/posters/Kręci mnie vinyl_LP.jpg', 2, 12, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (110, N'ELV1S', 2002, N'/posters/ELV1S_LP.jpg', 2, 50, 2, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (111, N'The Eminem Show', 2002, N'/posters/The Eminem Show_LP.jpg', 2, 51, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (112, N'Walsen Valses', 1964, N'/posters/112_walsen_valses_lp.jpg', 2, 52, 3, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (113, N'Appetite for Destruction', 1987, N'/posters/Appetite for Destruction_LP.jpg', 2, 53, 2, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (114, N'The Foundation', 2005, N'/posters/The Foundation_LP.jpg', 2, 54, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (115, N'Step in the Arena', 1990, N'/posters/Step in the Arena_LP.jpg', 2, 55, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (116, N'Hard to Earn', 1994, N'/posters/Hard to Earn_LP.jpg', 2, 55, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (117, N'Jazzmatazz, Vol. 1', 1993, N'/posters/Jazzmatazz, Vol. 1_LP.jpg', 2, 55, 1, NULL)
GO
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (118, N'Flip the Rat', 2019, N'/posters/Flip the Rat_LP.jpg', 2, 56, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (119, N'The Predator', 1992, N'/posters/The Predator_LP.jpg', 2, 57, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (120, N'Kansas', 1974, N'/posters/Kansas_LP.jpg', 2, 58, 2, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (121, N'Song for America', 1975, N'/posters/Song for America_LP.jpg', 2, 58, 2, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (122, N'Leftoverture', 1976, N'/posters/Leftoverture_LP.jpg', 2, 58, 2, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (123, N'Horyzont', 2020, N'/posters/Horyzont_LP.jpg', 2, 59, 3, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (124, N'Good Kid, M. A. A. D. City', 2012, N'/posters/Good Kid, MAAD City_LP.jpg', 2, 60, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (125, N'Sztuka jest skarpetką kulawego', 1987, N'/posters/Sztuka jest skarpetką kulawego_LP.jpg', 2, 61, 2, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (126, N'Kosi IS OK', 2021, N'/posters/Kosi IS OK_LP.jpg', 2, 62, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (127, N'I', 1969, N'/posters/127_i_lp.jpg', 2, 63, 2, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (129, N'II', 1969, N'/posters/129_ii_lp.jpg', 2, 63, 2, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (130, N'III', 1970, N'/posters/3_LP.jpg', 2, 63, 2, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (131, N'IV', 1971, N'/posters/4_LP.jpg', 2, 63, 2, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (132, N'MTV Unplugged', 2022, N'/posters/MTV Unplugged_LP.jpg', 2, 64, 2, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (133, N'You Want It Darker', 2016, N'/posters/133_you_want_it_darker_lp.jpg', 2, 65, 3, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (134, N'Łajzol Serious', 2022, N'/posters/134_lajzol_serious_lp.jpg', 2, 30, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (135, N'Hoboconcerten', 1965, N'/posters/Hoboconcerten_LP.jpg', 2, 66, 3, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (136, N'Ace of Spades', 1980, N'/posters/Ace of Spades_LP.jpg', 2, 67, 2, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (137, N'The Infamous', 1995, N'/posters/The Infamous_LP.jpg', 2, 68, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (138, N'Infamy', 2001, N'/posters/Infamy_LP.jpg', 2, 68, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (139, N'Straight Outta Compton', 1988, N'/posters/Straight Outta Compton_LP.jpg', 2, 69, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (140, N'Niggaz4Life', 1991, N'/posters/Niggaz4Life_LP.jpg', 2, 69, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (141, N'Illmatic', 1994, N'/posters/Illmatic_LP.jpg', 2, 70, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (142, N'#Turndafucup', 2014, N'/posters/142_turndafucup_lp.jpg', 2, 71, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (143, N'UNU', 1982, N'/posters/143_unu_lp.jpg', 2, 72, 2, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (144, N'Far Beyond Driven', 1994, N'/posters/Far Beyond Driven_LP.jpg', 2, 73, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (146, N'HIP HOP 50', 2023, N'/posters/hip_hop_50_cd.jpg', 1, 31, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (148, N'Ricardo', 2021, N'/posters/ricardo_cd.jpg', 1, 31, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (149, N'It Takes a Nation of Millions to Hold Us Back', 1988, N'/posters/it_takes_a_nation_of_millions_to_hold_us_back_lp.jpg', 2, 74, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (150, N'Fear of a Black Planet', 1990, N'/posters/fear_of_a_black_planet_lp.jpg', 2, 74, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (151, N'What You Gonna Do When The Grid Goes Down?', 2020, N'/posters/151_what_you_gonna_do_when_the_grid_goes_down_lp.jpg', 2, 74, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (152, N'Muzyka rozrywkowa', 2007, N'/posters/muzyka_rozrywkowa_lp.jpg', 2, 75, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (153, N'Greatest Hits', 1981, N'/posters/greatest_hits_lp.jpg', 2, 76, 2, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (154, N'Greatest Hits II', 1991, N'/posters/greatest_hits_ii_lp.jpg', 2, 76, 2, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (155, N'Raising Hell', 1986, N'/posters/raising_hell_lp.jpg', 2, 77, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (156, N'Rammstein', 2019, N'/posters/rammstein_lp.jpg', 2, 78, 2, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (157, N'Rosenrot', 2005, N'/posters/rosenrot_lp.jpg', 2, 78, 2, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (158, N'Mutter', 2001, N'/posters/mutter_lp.jpg', 2, 78, 2, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (159, N'Reise, Reise', 2004, N'/posters/reise_reise_lp.jpg', 2, 78, 2, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (160, N'1991', 1991, N'/posters/160_1991_lp.jpg', 2, 79, 2, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (161, N'Tha Last Meal', 2000, N'/posters/tha_last_meal_lp.jpg', 2, 80, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (162, N'Nic', 2021, N'/posters/nic_lp.jpg', 2, 17, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (163, N'PDG Gawrosz', 2011, N'/posters/pdg_gawrosz_lp.jpg', 2, 16, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (164, N'Powrót z drogi donikąd', 2021, N'/posters/powrt_z_drogi_donikd_lp.jpg', 2, 24, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (165, N'R&G (Rhythm & Gangsta): The Masterpiece', 2004, N'/posters/rg_rhythm__gangsta_the_masterpiece_lp.jpg', 2, 80, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (166, N'All Eyez on Me', 1996, N'/posters/all_eyez_on_me_lp.jpg', 2, 81, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (167, N'Szkoła wyrzutków', 2012, N'/posters/szkoa_wyrzutkw_lp.jpg', 2, 13, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (168, N'Trylogia Czarne Słońce', 2018, N'/posters/168_trylogia_czarne_slonce_lp.jpg', 2, 13, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (169, N'Monument', 2020, N'/posters/monument_lp.jpg', 2, 82, 2, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (170, N'Altitalienische Gitarrenkonzerte', 1969, N'/posters/altitalienische_gitarrenkonzerte_lp.jpg', 2, 83, 3, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (171, N'B&B Warsaw', 2023, N'/posters/bb_warsaw_lp.jpg', 2, 18, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (172, N'Obywatel G.C.', 1986, N'/posters/obywatel_gc_lp.jpg', 2, 84, 2, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (173, N'Produkt lokalny', 2023, N'/posters/produkt_lokalny_lp.jpg', 2, 16, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (174, N'One of the Best Yet', 2019, N'/posters/one_of_the_best_yet_lp.jpg', 2, 55, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (175, N'Whut? Thee Album', 1992, N'/posters/175_whut_thee_album_lp.jpg', 2, 85, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (176, N'Najemnik', 1989, N'/posters/najemnik_lp.jpg', 2, 86, 2, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (177, N'19 Naughty III', 1993, N'/posters/19_naughty_iii_lp.jpg', 2, 87, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (178, N'Naughty by Nature', 1991, N'/posters/naughty_by_nature_lp.jpg', 2, 87, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (179, N'Masz i pomyśl', 2000, N'/posters/masz_i_pomyl_lp.jpg', 2, 33, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (180, N'Enter the Wu-Tang (36 Chambers)', 1993, N'/posters/enter_the_wutang_36_chambers_lp.jpg', 2, 88, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (181, N'Wu-Tang Forever', 1997, N'/posters/181_wutang_forever_lp.jpg', 2, 88, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (182, N'Czysta brudna prawda', 2011, N'/posters/czysta_brudna_prawda_lp.jpg', 2, 17, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (183, N'Witam was w rzeczywistości', 2005, N'/posters/183_witam_was_w_rzeczywistosci_cd.jpg', 1, 33, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (184, N'Strictly Business', 1988, N'/posters/strictly_business_lp.jpg', 2, 89, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (185, N'Death Certificate', 1991, N'/posters/death_certificate_lp.jpg', 2, 57, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (186, N'AmeriKKKa’s Most Wanted', 1990, N'/posters/186_amerikkkas_most_wanted_lp.jpg', 2, 57, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (187, N'Capital Punishment', 1998, N'/posters/capital_punishment_lp.jpg', 2, 90, 1, NULL)
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (191, N'Eazy-Duz-It', 1988, N'/posters/191_eazyduzit_lp.jpg', 2, 91, 1, N'2024.04.21')
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (192, N'Back in Business', 1997, N'/posters/192_back_in_business_lp.jpg', 2, 89, 1, N'2024.04.21')
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (193, N'Paid in Full', 1987, N'/posters/193_paid_in_full_lp.jpg', 2, 92, 1, N'2024.04.21')
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (194, N'Highway to Hell', 1979, N'/posters/194_highway_to_hell_lp.jpg', 2, 93, 2, N'2024.04.21')
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (196, N'The Best. Rysunek na szkle', 2019, N'/posters/196_the_best_rysunek_na_szkle_lp.jpg', 2, 59, 3, N'2024.05.04')
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (197, N'Na legalu?', 2001, N'/posters/197_na_legalu_cd.jpg', 1, 31, 1, N'2024.06.01')
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (198, N'Alma Mater', 2019, N'/posters/198_alma_mater_lp.jpg', 2, 16, 1, N'2024.06.01')
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (199, N'Ponad Czas', 2023, N'/posters/199_ponad_czas_cd.jpg', 1, 38, 1, N'2024.06.01')
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (200, N'Na legalu? Na winylu', 2001, N'/posters/200_na_legalu_na_winylu_lp.jpg', 2, 31, 1, N'2024.06.01')
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (201, N'Black Album', 2020, N'/posters/201_black_album_cd.jpg', 1, 31, 1, N'2024.06.01')
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (202, N'The Rydas', 2020, N'/posters/202_the_rydas_lp.jpg', 2, 94, 1, N'2024.06.01')
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (203, N'Murda Muzik', 1999, N'/posters/203_murda_muzik_lp.jpg', 2, 68, 1, N'2024.06.11')
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (204, N'Return of the Boom Bap', 1993, N'/posters/204_return_of_the_boom_bap_lp.jpg', 2, 95, 1, N'2024.06.11')
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (205, N'Return of the Mac (Prodigy)', 2007, N'/posters/205_return_of_the_mac_prodigy_lp.jpg', 2, 68, 1, N'2024.07.07')
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (206, N'Music & Me', 2001, N'/posters/206_music__me_lp.jpg', 2, 96, 1, N'2024.07.07')
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (207, N'It’s Dark and Hell Is Hot', 1998, N'/posters/207_its_dark_and_hell_is_hot_lp.jpg', 2, 43, 1, N'2024.07.07')
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (208, N'Iron Flag', 2001, N'/posters/208_iron_flag_lp.jpg', 2, 88, 1, N'2024.07.07')
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (209, N'To Pimp a Butterfly', 2015, N'/posters/209_to_pimp_a_butterfly_lp.jpg', 2, 60, 1, N'2024.07.14')
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (210, N'PDG Repertuar', 2024, N'/posters/210_pdg_repertuar_cd.jpg', 1, 16, 1, N'2024.08.27')
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (211, N'Nie ma miejsca jak dom', 2002, N'/posters/211_nie_ma_miejsca_jak_dom_cd.jpg', 1, 40, 1, N'2024.08.27')
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (212, N'Dowód rzeczowy nr 3', 2013, N'/posters/212_dowod_rzeczowy_nr_3_cd.jpg', 1, 40, 1, N'2024.08.27')
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (213, N'Słowo dla ludzi cz.2: codzienność', 2011, N'/posters/213_sowo_dla_ludzi_cz2_codziennosc_cd.jpg', 1, 38, 1, N'2024.08.27')
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (214, N'Słowo dla ludzi cz.1', 2010, N'/posters/214_sowo_dla_ludzi_cz1_cd.jpg', 1, 38, 1, N'2024.08.27')
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (215, N'Mixtape 8', 2022, N'/posters/215_mixtape_8_cd.jpg', 1, 97, 1, N'2024.08.27')
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (216, N'Kodakrom', 2022, N'/posters/216_kodakrom_cd.jpg', 1, 16, 1, N'2024.08.27')
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (217, N'Songs of Love and Hate', 1971, N'/posters/217_songs_of_love_and_hate_lp.jpg', 2, 65, 3, N'2024.08.27')
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (218, N'Let the Rhythm Hit ''Em', 1990, N'/posters/218_let_the_rhythm_hit_em_lp.jpg', 2, 92, 1, N'2024.09.12')
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (219, N'Liebe ist für alle da', 2009, N'/posters/219_liebe_ist_fur_alle_da_lp.jpg', 2, 78, 2, N'2024.09.12')
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (220, N'Hatred, Passions and Infidelity', 1997, N'/posters/220_hatred_passions_and_infidelity_lp.jpg', 2, 98, 1, N'2024.09.12')
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (221, N'Stunts, Blunts & Hip Hop', 1992, N'/posters/221_stunts_blunts__hip_hop_lp.jpg', 2, 98, 1, N'2024.09.12')
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (222, N'Non Serviam Tom II Ważne Są Rzeczy Ważne', 2024, N'/posters/222_non_serviam_tom_ii_wazne_sa_rzeczy_wazne_cd.jpg', 1, 40, 1, N'2024.09.29')
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (223, N'Non Serviam Tom I', 2019, N'/posters/223_non_serviam_tom_1_cd.jpg', 1, 40, 1, N'2024.09.29')
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (224, N'Mixtape Vol. 6', 2018, N'/posters/224_mixtape_vol_6_lp.jpg', 2, 97, 1, N'2024.09.29')
GO
INSERT [dbo].[Albums] ([Id], [Title], [PublishDate], [Poster], [TypeId], [ArtistId], [CategoryId], [Date]) VALUES (225, N'Non Serviam Tom II Ważne Są Rzeczy Ważne', 2024, N'/posters/225_non_serviam_tom_ii_wazne_sa_rzeczy_wazne_tape.jpg', 3, 40, 1, N'2024.09.29')
SET IDENTITY_INSERT [dbo].[Albums] OFF
GO
SET IDENTITY_INSERT [dbo].[ArtistAlbums] ON 

INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (1, 13, 19)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (2, 13, 20)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (3, 9, 21)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (4, 16, 22)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (5, 16, 23)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (6, 8, 24)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (7, 13, 25)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (8, 17, 26)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (9, 8, 27)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (10, 8, 28)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (11, 8, 29)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (12, 8, 30)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (13, 8, 31)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (14, 8, 32)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (15, 18, 33)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (16, 18, 34)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (17, 18, 35)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (18, 19, 36)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (19, 19, 37)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (20, 20, 38)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (21, 20, 39)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (22, 20, 40)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (23, 20, 41)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (24, 21, 42)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (25, 19, 43)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (26, 19, 44)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (27, 22, 45)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (28, 18, 46)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (29, 18, 47)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (30, 18, 48)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (31, 18, 49)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (32, 23, 50)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (33, 23, 51)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (34, 24, 52)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (35, 25, 53)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (36, 26, 54)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (37, 26, 55)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (38, 26, 56)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (39, 26, 57)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (40, 27, 58)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (41, 28, 59)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (42, 28, 60)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (43, 28, 61)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (44, 29, 62)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (45, 30, 63)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (46, 26, 64)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (47, 26, 65)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (48, 26, 66)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (49, 31, 67)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (50, 32, 68)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (51, 32, 69)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (52, 17, 70)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (53, 17, 71)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (54, 33, 72)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (55, 34, 73)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (56, 33, 74)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (57, 17, 75)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (58, 17, 76)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (59, 35, 77)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (60, 36, 78)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (61, 37, 79)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (62, 37, 80)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (63, 37, 81)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (64, 37, 82)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (65, 37, 83)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (66, 38, 84)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (67, 38, 85)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (68, 39, 86)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (69, 18, 87)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (70, 38, 88)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (71, 38, 89)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (72, 40, 90)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (73, 16, 91)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (74, 41, 92)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (75, 42, 93)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (76, 42, 94)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (77, 43, 95)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (78, 43, 96)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (79, 43, 97)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (80, 43, 98)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (81, 44, 99)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (82, 44, 100)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (83, 45, 101)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (84, 45, 102)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (85, 45, 103)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (86, 46, 104)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (87, 47, 105)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (88, 48, 106)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (89, 48, 107)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (90, 49, 108)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (91, 12, 109)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (92, 50, 110)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (93, 51, 111)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (94, 52, 112)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (95, 53, 113)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (96, 54, 114)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (97, 55, 115)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (98, 55, 116)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (99, 55, 117)
GO
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (100, 56, 118)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (101, 57, 119)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (102, 58, 120)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (103, 58, 121)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (104, 58, 122)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (105, 59, 123)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (106, 60, 124)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (107, 61, 125)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (108, 62, 126)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (109, 63, 127)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (110, 63, 128)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (111, 63, 129)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (112, 63, 130)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (113, 63, 131)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (114, 64, 132)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (115, 65, 133)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (116, 30, 134)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (117, 66, 135)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (118, 67, 136)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (119, 68, 137)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (120, 68, 138)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (121, 69, 139)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (122, 69, 140)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (123, 70, 141)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (124, 71, 142)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (125, 72, 143)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (126, 73, 144)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (127, 31, 145)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (128, 31, 146)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (129, 49, 147)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (130, 31, 148)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (131, 74, 149)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (132, 74, 150)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (133, 74, 151)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (134, 75, 152)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (135, 76, 153)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (136, 76, 154)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (137, 77, 155)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (138, 78, 156)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (139, 78, 157)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (140, 78, 158)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (141, 78, 159)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (142, 79, 160)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (143, 80, 161)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (144, 17, 162)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (145, 16, 163)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (146, 24, 164)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (147, 80, 165)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (148, 81, 166)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (149, 13, 167)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (150, 13, 168)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (151, 82, 169)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (152, 83, 170)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (153, 18, 171)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (154, 84, 172)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (155, 16, 173)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (156, 55, 174)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (157, 85, 175)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (158, 86, 176)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (159, 87, 177)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (160, 87, 178)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (161, 33, 179)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (162, 88, 180)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (163, 88, 181)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (164, 17, 182)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (165, 33, 183)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (166, 89, 184)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (167, 57, 185)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (168, 57, 186)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (169, 90, 187)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (170, 56, 188)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (171, 56, 189)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (172, 56, 190)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (173, 91, 191)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (174, 89, 192)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (175, 92, 193)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (176, 93, 194)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (177, 37, 195)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (178, 59, 196)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (179, 31, 197)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (180, 16, 198)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (181, 38, 199)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (182, 31, 200)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (183, 31, 201)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (184, 94, 202)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (185, 68, 203)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (186, 95, 204)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (187, 68, 205)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (188, 96, 206)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (189, 43, 207)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (190, 88, 208)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (191, 60, 209)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (192, 16, 210)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (193, 40, 211)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (194, 40, 212)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (195, 38, 213)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (196, 38, 214)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (197, 97, 215)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (198, 16, 216)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (199, 65, 217)
GO
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (200, 92, 218)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (201, 78, 219)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (202, 98, 220)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (203, 98, 221)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (204, 40, 222)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (205, 40, 223)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (206, 97, 224)
INSERT [dbo].[ArtistAlbums] ([Id], [ArtistId], [AlbumId]) VALUES (207, 40, 225)
SET IDENTITY_INSERT [dbo].[ArtistAlbums] OFF
GO
SET IDENTITY_INSERT [dbo].[Artists] ON 

INSERT [dbo].[Artists] ([Id], [Name]) VALUES (8, N'Słoń')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (9, N'Opał')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (10, N'Bazi')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (12, N'Dj Soina')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (13, N'WSRH')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (16, N'Shellerini')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (17, N'Sokół')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (18, N'Kaz Bałagane')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (19, N'Rogal DDL')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (20, N'KęKę')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (21, N'Belmondo')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (22, N'Kaczor BRS')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (23, N'Avi x Louis Villain')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (24, N'Siwers')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (25, N'Akash')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (26, N'White House')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (27, N'Trzeci Wymiar')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (28, N'Szad')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (29, N'Bonus RPK')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (30, N'Łajzol')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (31, N'Peja')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (32, N'Sokół feat. Pono')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (33, N'WWO')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (34, N'ZIP Skład')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (35, N'Diox')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (36, N'Puff Daddy')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (37, N'Kafar Dix37')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (38, N'Dudek P56')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (39, N'Avi')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (40, N'Pih')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (41, N'Daab')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (42, N'Depeche Mode')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (43, N'DMX')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (44, N'Dr. Dre')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (45, N'Das EFX')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (46, N'Coolio')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (47, N'Budka Suflera')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (48, N'The Notorious B.I.G.')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (49, N'Black Sabbath')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (50, N'Elvis Presley')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (51, N'Eminem')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (52, N'Chopin')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (53, N'Guns N’ Roses')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (54, N'Geto Boys')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (55, N'Gang Starr')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (56, N'Insane Clown Posse')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (57, N'Ice Cube')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (58, N'Kansas')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (59, N'Krzysztof Krawczyk')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (60, N'Kendrick Lamar')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (61, N'Kobranocka')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (62, N'Kosi')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (63, N'Led Zeppelin')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (64, N'Lady Pank')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (65, N'Leonard Cohen')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (66, N'Mozart')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (67, N'Motorhead')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (68, N'Mobb Deep')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (69, N'N. W. A.')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (70, N'Nas')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (71, N'Onyx')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (72, N'Perfect')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (73, N'Pantera')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (74, N'Public Enemy')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (75, N'Pezet')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (76, N'Queen')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (77, N'Run-D.M.C.')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (78, N'Rammstein')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (79, N'Republika')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (80, N'Snoop Dogg')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (81, N'2Pac')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (82, N'Van Halen')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (83, N'Vivaldi')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (84, N'Obywatel G.C.')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (85, N'Redman')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (86, N'Dżem')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (87, N'Naughty by Nature')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (88, N'Wu-Tang Clan')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (89, N'EPMD')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (90, N'Big Pun')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (91, N'Eazy-E')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (92, N'Eric B. & Rakim')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (93, N'AC/DC')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (94, N'The Rydas')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (95, N'KRS-One')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (96, N'Nate Dogg')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (97, N'Dj Decks')
INSERT [dbo].[Artists] ([Id], [Name]) VALUES (98, N'Diamond D')
SET IDENTITY_INSERT [dbo].[Artists] OFF
GO
SET IDENTITY_INSERT [dbo].[Categories] ON 

INSERT [dbo].[Categories] ([Id], [Name]) VALUES (1, N'Rap')
INSERT [dbo].[Categories] ([Id], [Name]) VALUES (2, N'Rock')
INSERT [dbo].[Categories] ([Id], [Name]) VALUES (3, N'Inne')
SET IDENTITY_INSERT [dbo].[Categories] OFF
GO
SET IDENTITY_INSERT [dbo].[Types] ON 

INSERT [dbo].[Types] ([Id], [Name]) VALUES (1, N'CD')
INSERT [dbo].[Types] ([Id], [Name]) VALUES (2, N'LP')
INSERT [dbo].[Types] ([Id], [Name]) VALUES (3, N'Tape')
SET IDENTITY_INSERT [dbo].[Types] OFF
GO
/****** Object:  Index [IX_Albums_TypeId]    Script Date: 07.10.2024 23:25:39 ******/
CREATE NONCLUSTERED INDEX [IX_Albums_TypeId] ON [dbo].[Albums]
(
	[TypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Songs_AlbumId]    Script Date: 07.10.2024 23:25:39 ******/
CREATE NONCLUSTERED INDEX [IX_Songs_AlbumId] ON [dbo].[Songs]
(
	[AlbumId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Albums]  WITH CHECK ADD  CONSTRAINT [FK_Albums_Artists] FOREIGN KEY([ArtistId])
REFERENCES [dbo].[Artists] ([Id])
GO
ALTER TABLE [dbo].[Albums] CHECK CONSTRAINT [FK_Albums_Artists]
GO
ALTER TABLE [dbo].[Albums]  WITH CHECK ADD  CONSTRAINT [FK_Albums_Categories] FOREIGN KEY([CategoryId])
REFERENCES [dbo].[Categories] ([Id])
GO
ALTER TABLE [dbo].[Albums] CHECK CONSTRAINT [FK_Albums_Categories]
GO
ALTER TABLE [dbo].[Albums]  WITH CHECK ADD  CONSTRAINT [FK_Albums_Types_TypeId] FOREIGN KEY([TypeId])
REFERENCES [dbo].[Types] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Albums] CHECK CONSTRAINT [FK_Albums_Types_TypeId]
GO
USE [master]
GO
ALTER DATABASE [bazaMusic] SET  READ_WRITE 
GO
