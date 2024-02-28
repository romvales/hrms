
DROP TABLE IF EXISTS public.workers;
CREATE TABLE IF NOT EXISTS public.workers (
  "id" bigint generated by default as identity primary key,
  "userId" uuid null references auth.users(id) on delete cascade,

  -- When created by someone, manually set an 
  "createdById" bigint null references public.workers(id) on delete set null,
  "updatedById" bigint null references public.workers(id) on delete set null,

  "createdAt" timestamp not null default now(),
  "lastUpdatedAt" timestamp null,

  "pictureUrl" text null,
  "firstName" text not null,
  "lastName" text not null,
  "middleName" text null,

  "birthdate" date null,

  "username" text not null unique,
  "email" text not null unique,
  "mobile" text null,

  "flags" int not null default 0,

  -- Simplify addresses to JSON
  "addresses" json not null default '[]'::json
);


DROP TABLE IF EXISTS public."workerIdentityCards";
CREATE TABLE IF NOT EXISTS public."workerIdentityCards" (
  "id" bigint generated by default as identity primary key,
  -- Who owns this identity card?
  "workerId" bigint not null references public.workers(id) on delete cascade,
  "createdById" bigint null references public.workers(id) on delete set null,
  "updatedById" bigint null references public.workers(id) on delete set null,

  "createdAt" timestamp not null default now(),
  "lastUpdatedAt" timestamp null,

  "frontImageUrl" text not null default '',
  "backImageUrl" text not null default '',

  "name" text not null,

  -- TODO: Extract information from the `frontImageUrl` and `backImageUrl` using AI
  "extractedInfo" json null default '{}'::json,

  "flags" int not null default 0
);

-- @collection
DROP TABLE IF EXISTS public."workersIdentityCards";
CREATE TABLE IF NOT EXISTS public."workersIdentityCards" (
  "id" bigint generated by default as identity primary key, 
  "ownerId" bigint not null references public.workers(id) on delete cascade,
  "cardId" bigint not null references public."workerIdentityCards"(id) on delete cascade
);

DROP TABLE IF EXISTS public.organizations;
CREATE TABLE IF NOT EXISTS public.organizations (
  "id" bigint generated by default as identity primary key,

  "createdById" bigint null references public.workers(id) on delete set null,
  "updatedById" bigint null references public.workers(id) on delete set null,

  "createdAt" timestamp not null default now(),
  "lastUpdatedAt" timestamp null,

  "industry" smallint null,
  "overrideIndustry" text null,

  "name" text not null,

  "flags" int not null default 0,
);

-- @collection
DROP TABLE IF EXISTS public."organizationsMembers";
CREATE TABLE IF NOT EXISTS public."organizationsMembers" (
  "id" bigint generated by default as identity primary key,
  "organizationId" bigint not null references public.organizations(id) on delete cascade,
  "workerId" bigint not null references public.organizations(id) on delete cascade,

  -- TODO: Handle the case where a worker hires a worker
  "hiredById" bigint null references public.workers(id) on delete set null,

  "createdAt" timestamp not null default now(),
  "lastUpdatedAt" timestamp null,

  "hiredAt" date null,
  "suspendedAt" date null,
  "leaveAt" date null,
  "terminatedAt" date null,
  "returnedAt" date null,
  "scheduledSuspensionAt" date null,

  "flags" int not null default 0
);

-- @collection
DROP TABLE IF EXISTS public."workerOrganizations";
CREATE TABLE IF NOT EXISTS public."workerOrganizations" (
  "id" bigint generated by default as identity primary key,
  "workerId" bigint not null references public.organizations(id) on delete cascade,
  "organizationId" bigint not null references public.organizations(id) on delete cascade
);

DROP TABLE IF EXISTS public."pendingJoinRequests";  
CREATE TABLE IF NOT EXISTS public."pendingJoinRequests" (
  "id" bigint generated by default as identity primary key,
  "workerId" bigint not null references public.workers(id) on delete cascade,
  "organizationId" bigint not null references public.organizations(id) on delete cascade,

  "createdAt" timestamp not null default now(),
  "expiredAt" timestamp not null,

  "flags" int not null default 0
);

-- @collection
DROP TABLE IF EXISTS public."organizationsPendingRequests";
CREATE TABLE IF NOT EXISTS public."organizationsPendingRequests" (
  "id" bigint generated by default as identity primary key,
  "organizationId" bigint not null references public.organizations(id) on delete cascade,
  "requestId" bigint not null references public."pendingJoinRequests"(id) on delete cascade
);

-- @collection
DROP TABLE IF EXISTS public."workerPendingRequests";
CREATE TABLE IF NOT EXISTS public."workerPendingRequests" (
  "id" bigint generated by default as identity primary key,
  "workerId" bigint not null references public.workers(id) on delete cascade,
  "requestId" bigint not null references public."pendingJoinRequests"(id) on delete cascade
);

DROP TABLE IF EXISTS public."standardShifts";
CREATE TABLE IF NOT EXISTS public."standardShifts" (
  "id" bigint generated by default as identity primary key,
  "createdById" bigint null references public.workers(id) on delete set null,
  "updatedById" bigint null references public.workers(id) on delete set null,
  "organizationId" bigint not null references public.organizations(id) on delete cascade,

  "createdAt" timestamp not null default now(),
  "lastUpdatedAt" timestamp null,

  "name" text not null,
  "day" smallint not null,

  "clockIn" time not null,
  "clockOut" time not null
);

-- Scheduled override shifts
DROP TABLE IF EXISTS public."overrideShifts";
CREATE TABLE IF NOT EXISTS public."overrideShifts" (
  "id" bigint generated by default as identity primary key,
  "organizationId" bigint not null references public.organizations(id) on delete cascade,
  "createdById" bigint not null references public.workers(id) on delete set null,
  "updatedById" bigint null references public.workers(id) on delete set null,
  "workerId" bigint null references public.workers(id) on delete cascade,

  "createdAt" timestamp not null default now(),
  "lastUpdatedAt" timestamp null,
  "verifiedAt" timestamp null,
  "completedAt" timestamp null,

  "startsOn" date not null,
  "endsOn" date null,

  "name" text not null,
  -- What day will this overriden shift will start
  "day" smallint not null,

  "overrideClockIn" time not null,
  "overrideClockOut" time not null,

  "groupId" uuid not null,

  "flags" int not null default 0
);

DROP TABLE IF EXISTS public.attendances;
CREATE TABLE IF NOT EXISTS public.attendances (
  "id" bigint generated by default as identity primary key,
  "workerId" bigint null references public.workers(id) on delete set null,
  "shiftId" bigint null references public."standardShifts"(id) on delete set null,
  "oShiftId" bigint null references public."overrideShifts"(id) on delete set null,
  "createdById" bigint null references public.workers(id) on delete set null,
  "updatedById" bigint null references public.workers(id) on delete set null,

  "createdAt" timestamp not null default now(),
  "lastUpdatedAt" timestamp null,

  "clockIn" timestamp not null default now(),
  "clockOut" timestamp null,

  -- Represented in milliseconds
  "computed" numeric not null default 0,
  "underTime" numeric not null default 0,
  "overTime" numeric not null default 0,
  "lateTime" numeric not null default 0,
  "breakTime" numeric not null default 0
);

DROP TABLE IF EXISTS public.roles;
CREATE TABLE IF NOT EXISTS public.roles (
  "id" bigint generated by default as identity primary key,
  "createdById" bigint null references public.workers(id) on delete set null,
  "updatedById" bigint null references public.workers(id) on delete set null,
  "organizationId" bigint not null references public.organizations(id) on delete cascade,
  "createdAt" timestamp not null default now(),
  "lastUpdatedAt" timestamp null,
  "name" text not null unique,
  "flags" int not null default 0
);

-- @collection
DROP TABLE IF EXISTS public."workerRoles";
CREATE TABLE IF NOT EXISTS public."workerRoles" (
  "id" bigint generated by default as identity primary key,
  "roleId" bigint not null references public.roles(id) on delete cascade,
  "workerId" bigint not null references public.workers(id) on delete cascade
);

-- @collection
DROP TABLE IF EXISTS public."rolesStandardShifts";
CREATE TABLE IF NOT EXISTS public."rolesStandardShifts" (
  "id" bigint generated by default as identity primary key,
  "roleId" bigint not null references public.roles(id) on delete cascade,
  "standardShiftId" bigint not null references public."standardShifts"(id) on delete cascade
);

DROP TABLE IF EXISTS public.teams;
CREATE TABLE IF NOT EXISTS public.teams (
  "id" bigint generated by default as identity primary key,
  "createdById" bigint not null references public.workers(id) on delete cascade,
  "updatedById" bigint null references public.workers(id) on delete cascade,
  "organizationId" bigint not null references public.workers(id) on delete cascade,
  "createdAt" timestamp not null default now(),
  "lastUpdatedAt" timestamp null,
  "name" text not null,
  "flags" int not null default 0
);

-- @collection
DROP TABLE IF EXISTS public."teamsMembers";
CREATE TABLE IF NOT EXISTS public."teamsMembers" (
  "id" bigint generated by default as identity primary key,
  "teamId" bigint not null references public.teams(id) on delete cascade,
  "workerId" bigint not null references public.workers(id) on delete cascade
);

DROP TABLE IF EXISTS public.compensations;
CREATE TABLE IF NOT EXISTS public.compensations (
  "id" bigint generated by default as identity primary key,
  "createdById" bigint null references public.workers(id) on delete set null,
  "updatedById" bigint null references public.workers(id) on delete set null,
  "organizationId" bigint not null references public.organizations(id) on delete cascade,
  "workerId" bigint not null references public.workers(id) on delete set null,
  "createdAt" timestamp not null default now(),
  "lastUpdatedAt" timestamp null,
  "paidAt" timestamp null,
  "approvedAt" timestamp null,
  "rejectedAt" timestamp null,
  "periodStart" date not null,
  "periodEnd" date not null,
  "gvalue" numeric not null,
  "avalue" numeric not null default 0,
  "dvalue" numeric not null default 0,
  "value" numeric not null default 0,
  "flags" int not null default 0
);

DROP TABLE IF EXISTS public.additions;
CREATE TABLE IF NOT EXISTS public.additions (
  "id" bigint generated by default as identity primary key,
  "createdById" bigint null references public.workers(id) on delete set null,
  "updatedById" bigint null references public.workers(id) on delete set null,
  "workerId" bigint null references public.workers(id) on delete cascade,
  "createdAt" timestamp not null default now(),
  "lastUpdatedAt" timestamp null,
  "effectiveAt" timestamp null,
  "name" text null,
  "value" numeric not null default 0,
  "flags" int not null default 0
);

DROP TABLE IF EXISTS public.deductions;
CREATE TABLE IF NOT EXISTS public.deductions (
  "id" bigint generated by default as identity primary key,
  "createdById" bigint null references public.workers(id) on delete set null,
  "updatedById" bigint null references public.workers(id) on delete set null,
  "workerId" bigint null references public.workers(id) on delete cascade,

  "createdAt" timestamp not null default now(),
  "lastUpdatedAt" timestamp null,
  "effectiveAt" timestamp null,
  "name" text null,
  "value" numeric not null default 0,
  "flags" int not null default 0
);

-- @collection
DROP TABLE IF EXISTS public."compensationsAdditions";
CREATE TABLE IF NOT EXISTS public."compensationsAdditions" (
  "id" bigint generated by default as identity primary key,
  "compensationId" bigint not null references public.compensations(id) on delete cascade,
  "additionId" bigint not null references public.additions(id) on delete cascade
);

-- @collection
DROP TABLE IF EXISTS public."compensationsDeductions";
CREATE TABLE IF NOT EXISTS public."compensationsDeductions" (
  "id" bigint generated by default as identity primary key,
  "compensationId" bigint not null references public.compensations(id) on delete cascade,
  "deductionId" bigint not null references public.deductions(id) on delete cascade
);

DROP TABLE IF EXISTS public.payrolls;
CREATE TABLE IF NOT EXISTS public.payrolls (
  "id" bigint generated by default as identity primary key,
  "createdById" bigint null references public.workers(id) on delete set null,
  "updatedById" bigint null references public.workers(id) on delete set null,
  "verifiedById" bigint null references public.workers(id) on delete set null,
  "organizationId" bigint null references public.organizations(id) on delete cascade,
  "createdAt" timestamp not null default now(),
  "lastUpdatedAt" timestamp null,
  "flags" int not null default 0,
  "total" numeric not null default 0
);

-- @collection
DROP TABLE IF EXISTS public."payrollCompensations";
CREATE TABLE IF NOT EXISTS public."payrollCompensations" (
  "id" bigint generated by default as identity primary key,
  "payrollId" bigint not null references public.payrolls(id) on delete cascade,
  "compensationId" bigint not null references public.compensations(id) on delete cascade
);
