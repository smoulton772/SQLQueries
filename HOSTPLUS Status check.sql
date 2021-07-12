USE CMXGlobalDB

Select HostPlus_Sessions.Server, HTks.Status, HTks.Error, HTks.IsActive, Progress, HTks.Description, Timer, TimerType, HTks.LastDate, HTks.NextDate, *
From HostPlus_SessionTasks HTks Left Outer Join HostPlus_Sessions on HTks.SessionId = HostPlus_Sessions.RecId
Where HTks.IsActive = 1 --- and LastDate > '6/01/2021'
Order By -- HostPlus_Sessions.Server, HTks.LastDate
HTks.Status, HTks.LastDate