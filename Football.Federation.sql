CREATE TABLE Person (
    PersonID SERIAL PRIMARY KEY, 
    FullEnglishName TEXT NOT NULL,
    FullPersianName TEXT NOT NULL,
    ResidenceAddress TEXT,
    DateOfBirth DATE NOT NULL,
    Nationality TEXT NOT NULL,
    IDNumber INT UNIQUE,
    PassportNumber INT UNIQUE,
    DateOfJoining DATE NOT NULL
);

CREATE TABLE Federation (
    FID SERIAL PRIMARY KEY
);

CREATE TABLE FootBallClub (
    FederationID INT NOT NULL,
    FCID SERIAL PRIMARY KEY, 
    City TEXT NOT NULL,
    FCName TEXT NOT NULL,
    DateOfEstablishment DATE NOT NULL,
    FOREIGN KEY (FederationID) REFERENCES Federation(FID)
);

CREATE TABLE League (
    LeagueID SERIAL PRIMARY KEY,
    NameOfLeague TEXT
);

CREATE TABLE Season (
    LeagueID INT,
    SeasonID SERIAL UNIQUE,
    DateOfStart DATE,
    DateOFEnd DATE,
    FOREIGN KEY (LeagueID) REFERENCES League(LeagueID),
    PRIMARY KEY (LeagueID, SeasonID)
);

CREATE TABLE Arrangement (
    FCID INT,
    ID SERIAL UNIQUE,
    SeasonID INT NOT NULL,
    Score INT NOT NULL DEFAULT 0 CHECK (Score >= 0),
    Rank INT NOT NULL DEFAULT 1 CHECK (Rank >= 1),
    FOREIGN KEY (FCID) REFERENCES FootBallClub(FCID),
    FOREIGN KEY (SeasonID) REFERENCES Season(SeasonID),
    PRIMARY KEY (FCID, ID)
);

CREATE TABLE Player (
    PersonID INT NOT NULL UNIQUE,
    PlayerID SERIAL PRIMARY KEY,
    FCID INT,
    ID INT,
    FOREIGN KEY (PersonID) REFERENCES Person(PersonID),
    FOREIGN KEY (FCID) REFERENCES FootBallClub(FCID),
    FOREIGN KEY (ID) REFERENCES Arrangement(ID)
);

CREATE TYPE Posts AS ENUM ('Head Coach', 'Coach', 'Doctor', 'Manager');

CREATE TABLE Staff (
    PersonID INT NOT NULL UNIQUE,
    StaffID SERIAL PRIMARY KEY,
    Post Posts NOT NULL,
    FOREIGN KEY (PersonID) REFERENCES Person(PersonID)
);

CREATE TABLE Referee (
    PersonID INT NOT NULL UNIQUE,
    RefereeID SERIAL PRIMARY KEY,
    FOREIGN KEY (PersonID) REFERENCES Person(PersonID)
);

CREATE TABLE FederationLeagues (
    FID INT,
    LeagueID INT,
    FOREIGN KEY (FID) REFERENCES Federation(FID),
    FOREIGN KEY (LeagueID) REFERENCES League(LeagueID),
    PRIMARY KEY (FID, LeagueID)
);

CREATE TABLE WeekTime (
    SeasonID INT,
    DateOfStart DATE,
    DateOFEnd DATE,
    WeekID SERIAL UNIQUE,
    FOREIGN KEY (SeasonID) REFERENCES Season(SeasonID),
    PRIMARY KEY (SeasonID, WeekID)
);

CREATE TABLE Game (
    WeekID INT,
    TimeOfGame TIMESTAMP,
    GameID SERIAL UNIQUE,
    FOREIGN KEY (WeekID) REFERENCES WeekTime(WeekID),
    PRIMARY KEY (WeekID, GameID)
);

CREATE TABLE EventInGame (
    GameID INT,
    EventID SERIAL UNIQUE, 
    TimeOfEvent TIME,
    FOREIGN KEY (GameID) REFERENCES Game(GameID),
    PRIMARY KEY (GameID, EventID)
);

CREATE TABLE Goal (
    EventID INT PRIMARY KEY,
    Kicker INT NOT NULL,
    GoalID SERIAL UNIQUE, 
    FOREIGN KEY (EventID) REFERENCES EventInGame(EventID),
    FOREIGN KEY (Kicker) REFERENCES Player(PlayerID)
);

CREATE TABLE Foul (
    EventID INT PRIMARY KEY,
    Doer INT NOT NULL,
    Doee INT NOT NULL,
    FoulID SERIAL UNIQUE, 
    FOREIGN KEY (EventID) REFERENCES EventInGame(EventID),
    FOREIGN KEY (Doer) REFERENCES Player(PlayerID),
    FOREIGN KEY (Doee) REFERENCES Player(PlayerID),
    CONSTRAINT DifferentPlayers CHECK (Doer != Doee)
);

CREATE TABLE Substitution (
    EventID INT PRIMARY KEY,
    Comming INT NOT NULL,
    Going INT NOT NULL,
    SubstitutionID SERIAL UNIQUE, 
    FOREIGN KEY (EventID) REFERENCES EventInGame(EventID),
    FOREIGN KEY (Comming) REFERENCES Player(PlayerID),
    FOREIGN KEY (Going) REFERENCES Player(PlayerID),
    CONSTRAINT DifferentPlayers CHECK (Comming != Going)
);

CREATE TABLE YellowCard (
    EventID INT PRIMARY KEY,
    StaffID INT,
    PlayerID INT,
    YellowCardID SERIAL UNIQUE,
    FOREIGN KEY (EventID) REFERENCES EventInGame(EventID),
    FOREIGN KEY (StaffID) REFERENCES Staff(StaffID),
    FOREIGN KEY (PlayerID) REFERENCES Player(PlayerID),
    CONSTRAINT OneGetter CHECK ((StaffID IS NULL AND PlayerID IS NOT NULL) OR (PlayerID IS NULL AND StaffID IS NOT NULL))
);

CREATE TYPE RedCards AS ENUM ('Direct', 'Undirect');

CREATE TABLE RedCard (
    EventID INT PRIMARY KEY,
    TypeOfCard RedCards,
    StaffID INT,
    PlayerID INT,
    RedCardID SERIAL UNIQUE, 
    FOREIGN KEY (EventID) REFERENCES EventInGame(EventID),
    FOREIGN KEY (StaffID) REFERENCES Staff(StaffID),
    FOREIGN KEY (PlayerID) REFERENCES Player(PlayerID),
    CONSTRAINT OneGetter CHECK ((StaffID IS NULL AND PlayerID IS NOT NULL) OR (PlayerID IS NULL AND StaffID IS NOT NULL))
);

CREATE TABLE Stadium (
    StadiumID SERIAL PRIMARY KEY,
    City TEXT NOT NULL,
    AddressOfStaduim TEXT NOT NULL UNIQUE,
    Capacity INT NOT NULL,
    Features TEXT[],
    PriceOfTicket Float NOT NULL
);


CREATE TABLE Committee (
    SeasonID INT,
    CommitteeID SERIAL UNIQUE,
    FOREIGN KEY (SeasonID) REFERENCES Season(SeasonID),
    PRIMARY KEY (SeasonID, CommitteeID)
);

CREATE TABLE RefereeCanSupervise (
    RefereeID INT,
    LeagueID INT,
    FOREIGN KEY (RefereeID) REFERENCES Referee(RefereeID),
    FOREIGN KEY (LeagueID) REFERENCES League(LeagueID),
    PRIMARY KEY (RefereeID, LeagueID)
);

CREATE TABLE RefereeIsInCommittee (
    RefereeID INT,
    CommitteeID INT,
    FOREIGN KEY (RefereeID) REFERENCES Referee(RefereeID),
    FOREIGN KEY (CommitteeID) REFERENCES Committee(CommitteeID),
    PRIMARY KEY (RefereeID, CommitteeID)
);

CREATE TYPE RefereeType AS ENUM ('Main', 'FirstAssistant', 'SecondAssistant', 'Fourth');

CREATE TABLE RefereeIsInGame (
    RefereeID INT,
    GameID INT,
    TypeOfReferee RefereeType,
    Score INT CHECK (Score >= 1 AND Score <= 10),
    FOREIGN KEY (RefereeID) REFERENCES Referee(RefereeID),
    FOREIGN KEY (GameID) REFERENCES Game(GameID),
    PRIMARY KEY (RefereeID, GameID)
);

CREATE TABLE RefereeSupervises (
    RefereeID INT,
    GameID INT PRIMARY KEY,
    DescriptionOfGame TEXT,
    FOREIGN KEY (RefereeID) REFERENCES Referee(RefereeID),
    FOREIGN KEY (GameID) REFERENCES Game(GameID)
);

CREATE TABLE PlaceOfGame (
    GameID INT PRIMARY KEY,
    StadiumID INT,
    FOREIGN KEY (GameID) REFERENCES Game(GameID),
    FOREIGN KEY (StadiumID) REFERENCES Stadium(StadiumID)
);

CREATE TYPE PlayerType AS ENUM ('Main', 'Substitution');

CREATE TABLE Plays(
    PlayerID INT NOT NULL,
    GameID INT NOT NULL,
    TypeOfPlayer PlayerType,
    FOREIGN KEY (PlayerID) REFERENCES Player(PlayerID),
    FOREIGN KEY (GameID) REFERENCES Game(GameID),
    PRIMARY KEY (PlayerID, GameID)
);

CREATE TABLE Participate (
    StaffID INT NOT NULL,
    GameID INT NOT NULL,
    FOREIGN KEY (StaffID) REFERENCES Staff(StaffID),
    FOREIGN KEY (GameID) REFERENCES Game(GameID),
    PRIMARY KEY (StaffID, GameID)
);

CREATE TYPE EarnedScoreType AS ENUM ('0', '1', '3');

CREATE TYPE StatusOfGameType AS ENUM ('Winner', 'Loser', 'Draw');

CREATE TYPE HostType AS ENUM ('Host', 'Guest');

CREATE TABLE GamesDone (
    ID INT,
    GameID INT,
    SuccessfullPasses INT NOT NULL DEFAULT 0 CHECK (SuccessfullPasses >= 0),
    Passes INT NOT NULL DEFAULT 0 CHECK (Passes >= 0 AND Passes >= SuccessfullPasses),
    Position FLOAT NOT NULL DEFAULT 0 CHECK (Position >= 0 AND Position <= 100),
    EarnedScore EarnedScoreType NOT NULL DEFAULT '0',
    GoalScored INT NOT NULL DEFAULT 0 CHECK (GoalScored >= 0),
    StatusOfGame StatusOfGameType NOT NULL DEFAULT 'Draw',
    Host HostType NOT NULL DEFAULT 'Host',
    GoalGet INT NOT NULL DEFAULT 0 CHECK (GoalGet >= 0),
    InGoalKick INT NOT NULL DEFAULT 0 CHECK (InGoalKick >= 0),
    Offside INT NOT NULL DEFAULT 0 CHECK (Offside >= 0),
    Corner INT NOT NULL DEFAULT 0 CHECK (Corner >= 0),
    Dangerous INT NOT NULL DEFAULT 0 CHECK (Dangerous >= 0),
    FOREIGN KEY (ID) REFERENCES Arrangement(ID),
    FOREIGN KEY (GameID) REFERENCES Game(GameID),
    PRIMARY KEY (ID, GameID)
)