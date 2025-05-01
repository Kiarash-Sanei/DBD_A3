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

CREATE TABLE FootBallClub (
    FederationID NOT NULL,
    FCID SERIAL PRIMARY KEY, 
    City TEXT NOT NULL,
    FCName TEXT NOT NULL,
    DateOfEstablishment DATE NOT NULL,
    FOREIGN KEY FederationID REFERENCES Federation(FID)
);

CREATE TABLE Arrangement (
    FCID,
    ID SERIAL,
    SeasonID NOT NULL,
    Score INT NOT NULL DEFAULT 0 CHECK (Score >= 0),
    Rank INT NOT NULL DEFAULT 1 CHECK (Rank >= 1),
    FOREIGN KEY (FCID) REFERENCES FootBallClub(FCID),
    FOREIGN KEY (SeasonID) REFERENCES Season(SeasonID),
    PRIMARY KEY (FCID, ID)
);

CREATE TABLE Player (
    PersonID NOT NULL UNIQUE,
    PlayerID SERIAL PRIMARY KEY,
    FCID,
    ID,
    FOREIGN KEY (PersonID) REFERENCES Person(PersonID),
    FOREIGN KEY (FCID) REFERENCES FootBallClub(FCID),
    FOREIGN KEY (ID) REFERENCES Arrangement(ID)
);

CREATE TYPE Posts AS ENUM ('Head Coach', 'Coach', 'Doctor', 'Manager');

CREATE TABLE Staff (
    PersonID NOT NULL UNIQUE,
    StaffID SERIAL PRIMARY KEY,
    Post Posts NOT NULL,
    FOREIGN KEY (PersonID) REFERENCES Person(PersonID)
);

CREATE TABLE Referee (
    PersonID NOT NULL UNIQUE,
    RefereeID SERIAL PRIMARY KEY,
    FOREIGN KEY (PersonID) REFERENCES Person(PersonID)
);

CREATE TABLE Federation (
    FID SERIAL PRIMARY KEY,
);

CREATE TABLE FederationLeagues {
    FID,
    LeagueID,
    FOREIGN KEY (FID) REFERENCES Federation(FID),
    FOREIGN KEY (LeagueID) REFERENCES League(LeagueID),
    PRIMARY KEY (FID, LeagueID)
}

CREATE TABLE League (
    LeagueID SERIAL PRIMARY KEY,
    NameOfLeague TEXT,
);

CREATE TABLE Season (
    LeagueID,
    SeasonID SERIAL UNIQUE,
    DateOfStart DATE,
    DateOFEnd DATE,
    FOREIGN KEY (LeagueID) REFERENCES League(LeagueID),
    PRIMARY KEY (LeagueID, SeasonID)
);

CREATE TABLE WeekTime (
    SeasonID,
    DateOfStart DATE,
    DateOFEnd DATE,
    WeekID SERIAL UNIQUE,
    FOREIGN KEY (SeasonID) REFERENCES Season(SeasonID),
    PRIMARY KEY (SeasonID, WeekID)
);

CREATE TABLE Game (
    WeekID,
    TimeOfGame TIMESTAMP,
    GameID SERIAL UNIQUE,
    FOREIGN KEY (WeekID) REFERENCES WeekTime(WeekID),
    PRIMARY KEY (WeekID, GameID)
);

CREATE TABLE EventInGame (
    GameID,
    EventID SERIAL UNIQUE, 
    TimeOfEvent TIME,
    FOREIGN KEY (GameID) REFERENCES Game(GameID),
    PRIMARY KEY (GameID, EventID)
);

CREATE TABLE Goal (
    EventID PRIMARY KEY,
    Kicker NOT NULL,
    GoalID SERIAL UNIQUE, 
    FOREIGN KEY (EventID) REFERENCES EventInGame(EventID),
    FOREIGN KEY (Kicker) REFERENCES Player(PlayerID),
);

CREATE TABLE Foul (
    EventID PRIMARY KEY,
    Doer NOT NULL,
    Doee NOT NULL,
    FoulID SERIAL UNIQUE, 
    FOREIGN KEY (EventID) REFERENCES EventInGame(EventID),
    FOREIGN KEY (Doer) REFERENCES Player(PlayerID),
    FOREIGN KEY (Doee) REFERENCES Player(PlayerID),
    CONSTRAINT DifferentPlayers CHECK (Doer != Doee)
);

CREATE TABLE Substitution (
    EventID PRIMARY KEY,
    Comming NOT NULL,
    Going NOT NULL,
    SubstitutionID SERIAL UNIQUE, 
    FOREIGN KEY (EventID) REFERENCES EventInGame(EventID),
    FOREIGN KEY (Comming) REFERENCES Player(PlayerID),
    FOREIGN KEY (Going) REFERENCES Player(PlayerID),
    CONSTRAINT DifferentPlayers CHECK (Comming != Going)
);

CREATE TABLE YellowCard (
    EventID PRIMARY KEY,
    Staff,
    Player,
    YellowCardID SERIAL UNIQUE,
    FOREIGN KEY (EventID) REFERENCES EventInGame(EventID),
    FOREIGN KEY (Staff) REFERENCES Staff(StaffID),
    FOREIGN KEY (Player) REFERENCES Player(PlayerID),
    CONSTRAINT OneGetter CHECK ((Staff IS NULL AND Player IS NOT NULL) OR (Player IS NULL AND Staff IS NOT NULL))
);

CREATE TYPE RedCards AS ENUM ('Direct', 'Undirect');

CREATE TABLE RedCard (
    EventID PRIMARY KEY,
    TypeOfCard RedCards,
    Staff,
    Player,
    RedCardID SERIAL UNIQUE, 
    FOREIGN KEY (EventID) REFERENCES EventInGame(EventID),
    FOREIGN KEY (Staff) REFERENCES Staff(StaffID),
    FOREIGN KEY (Player) REFERENCES Player(PlayerID),
    CONSTRAINT OneGetter CHECK ((Staff IS NULL AND Player IS NOT NULL) OR (Player IS NULL AND Staff IS NOT NULL))
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
    SeasonID,
    CommitteeID SERIAL UNIQUE,
    FOREIGN KEY (SeasonID) REFERENCES Season(SeasonID),
    PRIMARY KEY (SeasonID, CommitteeID)
);

CREATE TABLE RefereeCanSupervise (
    RefereeID,
    LeagueID,
    FOREIGN KEY (RefereeID) REFERENCES Referee(RefereeID),
    FOREIGN KEY (LeagueID) REFERENCES League(LeagueID),
    PRIMARY KEY (RefereeID, LeagueID)
);

CREATE TABLE RefereeIsInCommittee (
    RefereeID,
    CommitteeID,
    FOREIGN KEY (RefereeID) REFERENCES Referee(RefereeID),
    FOREIGN KEY (CommitteeID) REFERENCES Committee(CommitteeID),
    PRIMARY KEY (RefereeID, LeagueID)
);

CREATE TYPE RefereeType AS ENUM ('Main', 'FirstAssistant', 'SecondAssistant', 'Fourth');

CREATE TABLE RefereeIsInGame (
    RefereeID,
    GameID,
    TypeOfReferee RefereeType,
    Score INT CHECK (Score >= 1 AND Score <= 10),
    FOREIGN KEY (RefereeID) REFERENCES Referee(RefereeID),
    FOREIGN KEY (GameID) REFERENCES Game(GameID),
    PRIMARY KEY (RefereeID, GameID)
);

CREATE TABLE RefereeSupervises (
    RefereeID,
    GameID PRIMARY KEY,
    DescriptionOfGame TEXT,
    FOREIGN KEY (RefereeID) REFERENCES RefereeCanSupervise(RefereeID),
    FOREIGN KEY (GameID) REFERENCES Game(GameID),
);

CREATE TABLE PlaceOfGame (
    GameID PRIMARY KEY,
    StadiumID,
    FOREIGN KEY (GameID) REFERENCES Game(GameID),
    FOREIGN KEY (StadiumID) REFERENCES Stadium(StadiumID),
);

CREATE TYPE PlayerType AS ENUM ('Main', 'Substitution');

CREATE TABLE Plays(
    PlayerID NOT NULL,
    GameID NOT NULL,
    TypeOfPlayer PlayerType,
    FOREIGN KEY (PlayerID) REFERENCES Player(PlayerID),
    FOREIGN KEY (GameID) REFERENCES Game(GameID),
    PRIMARY KEY (PlayerID, GameID)
);

CREATE TABLE Participate (
    StaffID NOT NULL,
    GameID NOT NULL,
    FOREIGN KEY (StaffID) REFERENCES Staff(StaffID),
    FOREIGN KEY (GameID) REFERENCES Game(GameID),
    PRIMARY KEY (StaffID, GameID)
)

CREATE TABLE GamesDone (
    ID,
    GameID,
    SuccessfullPasses INT NOT NULL DEFAULT 0 CHECK (SuccessfullPasses >= 0),
    Passes INT NOT NULL DEFAULT 0 CHECK (Passes >= 0 AND Passes >= SuccessfullPasses),
    Position FLOAT NOT NULL DEFAULT 0 CHECK (Position >= 0 AND Position <= 100),
    EarnedScore INT NOT NULL DEFAULT 0 CHECK (EarnedScore == 0 OR EarnedScore == 1 OR EarnedScore == 3),
    GoalScored INT NOT NULL DEFAULT 0 CHECK (GoalScored >= 0),
    StatusOfGame TEXT NOT NULL DEFAULT 'Draw' CHECK (StatusOfGame == 'Winner' OR StatusOfGame == 'Loser' OR StatusOfGame == 'Draw'),
    Host TEXT NOT NULL DEFAULT 'Host' CHECK (Host == 'Host' OR Host == 'Guest'),
    GoalGet INT NOT NULL DEFAULT 0 CHECK (GoalGet >= 0),
    InGoalKick INT NOT NULL DEFAULT 0 CHECK (InGoalKick >= 0),
    Offside INT NOT NULL DEFAULT 0 CHECK (Offside >= 0),
    Corner INT NOT NULL DEFAULT 0 CHECK (Corner >= 0),
    Dangerous INT NOT NULL DEFAULT 0 CHECK (Dangerous >= 0),
    FOREIGN KEY (ID) REFERENCES Arrangement(ID),
    FOREIGN KEY (GameID) REFERENCES Game(GameID),
    PRIMARY KEY (ID, GameID)
)