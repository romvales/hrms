# A specification document for the HRMS

### A collection of interfaces to where our system will be depending on

## Table of contents

1. Terminologies
2. A General Rule of Thumb

## Terminologies

Human Resource Management System (HRMS), is a software designed to automate various HR functions within an organization. **It reduces the manual labor in managing employee data, payroll, benefits administration, recruitment, performance management, time tracking, and other functions related to human resource.**

## A General Rule of Thumb

Each interfaces that will be described in this source must be followed accordingly so that there will be no confusions throughout the development cycle and helps make your HRMS robust.

Below are the types, enums and interfaces that will be outlined:

1. Worker

- Role
- Team
- Worker
- WorkerOrganizationInfo
- WorkerIdentityCard
- WorkerAddress
- enum:WorkerIndicator
- enum:WorkerOrganizationPayCycle
- enum:WorkerAddressType
- enum:WorkerGender
- enum:WorkerOrganizationStatus
- enum:WorkerOrganizationType
- enum:TeamStatus
- enum:RoleStatus

- HCMRoleService

1. createRole(name: string)
2. getRoleById()
3. deleteRoleById()
4. saveRole()
5. changeRoleName()
6. changeRoleStatus()
7. getRoleShifts()
8. addStandardShift()
9. updateStandardShift()
10. containsCompleteStandardShift()
11. isActive()
12. isInactive()
13. isOnReview()
14. isTerminated()
15. isDisabled()

- HCMTeamService

1. createTeam(name: string)
2. getTeamById(teamId: number)
3. deleteTeamById(teamId: number)
4. saveTeam(team: Team)
5. changeTeamName(name: string)
6. changeTeamStatus(status: TeamStatus)
7. getWorkerMembers()
8. addWorkerToTeam(team: Team, worker: Worker)
9. deleteWorkerFromTeam(team: Team, worker: Worker)
10. isActive()
11. isInactive()
12. isOnReview()
13. isTerminated()
14. isDisabled()

- HCMWorkerService

1. createWorker(email: string, username: string)
2. getWorkerById(workerId: number)
3. deleteWorkerById(workerId: number)
4. saveWorker()
5. addWorkerAddress(address: WorkerAddress)
6. addIdentityCards(cards: WorkerIdentityCard[])
7. changeWorkerIndicator(indicator: WorkerIndicator)
8. assignUserToWorker(user: User | null) -> supabaseImplementation
9. getWorkerByUser(user: User) -> supabaseImplementation
10. getIdentityCards()
11. getAddresses()
12. deleteIdentityCardById(id: number)
13. saveWorkerIdentityCard()
14. changeName(name: { firstName: string, lastName: string, ... })
15. changePictureUrl(pictureUrl: string)
16. changeBirthdate(birthdate: number)
17. changeEmailAddress(newEmail: string)
18. changeMobileNumber(newMobile: string)
19. changeGender(gender: WorkerGender)

- HCMWorkerOrganizationInfoService

<!-- I decided to separate fields related to organizations so that workers are able to -->
<!-- join and contribute to various organizations available in the platform. -->

1. getOrganizations(worker: Worker)
2. getRoles(worker: Worker)
3. getTeams(worker: Worker)
4. getWorkerType()
5. getWorkerStatus()
6. getAddresses()
7. getIdentityCards()
8. getOrganization()
9. getRole()
10. getTeam()
11. hasOverridenStandardRoleShift()
12. isWorkerHired(worker: Worker)
13. isWorkerOnLeave(worker: Worker)
14. isWorkerRemote(worker: Worker)
15. isWorkerOnline(worker: Worker)
16. isWorkerRemotelyOnline(worker: Worker)
17. isWorkerOffline(worker: Worker)
18. isWorkerAway(worker: Worker)
19. isWorkerSuspended(worker: Worker)
20. isWorkerOnCall(worker: Worker)
21. suspend(worker: Worker)
22. terminate(worker: Worker)
23. resign(worker: Worker)
24. changeWorkerStatus(status: WorkerStatus)
25. changeWorkerType(type: WorkerType)
26. changeWorkerRole(roleId: number)
27. changeWorkerTeam(teamId: number)
28. changeWorkerPayCycle(cycle: WorkerPayCycle)

- #BaseOrganizationEntityStatusChecker(Entity = unknown)

1. isActive(entity: Entity)
2. isInactive(entity: Entity)
3. isOnReview(entity: Entity)
4. isTerminated(entity: Entity)

2. Shifts

- StandardShift
- OverrideShift
- enum:StandardShiftDay

- HCMWorkerShiftService

3. Attendance

- Attendance
- enum:AttendanceType
- enum:AttendanceStatus
- enum:AttendancePerformanceLabel
- enum:AttendanceClockInType
- enum:AttendanceClockOutType

- HCMAttendanceService

1. createAttendance(worker: Worker, clockIn: number)
2. getAttendanceById(attendanceId: number)
3. deleteAttendanceById(attendanceId: number)
4. saveAttendance(attendance: Attendance)
4. changeStatus(attendance: Attendance, status: AttendanceStatus)
5. changeType(attendance: Attendance, type: AttendanceType)
6. changePerfLabel(attendance: Attendance, label: AttendancePerfomanceLabel)
7. changeClockInType(attendance: Attendance, type: AttendanceClockInType)
8. changeClockOutType(attendance: Attendance, type: AttendanceClockOutType)
9. clockIn(worker: Worker, type: AttendanceClockInType)
10. clockOut(worker: Worker, type: AttendanceClockOutType)
11. getShift(attendance: Attendance)
12. isLate(attendance: Attendance)
13. isOverride(attendance: Attendance)
14. isHoliday(attendance: Attendance)
15. isBreak(attendance: Attendance)

4. Payroll

- Payroll
- enum:PayrollStatus
- enum:PayrollPayCycleType

- HCMPayrollService

1. createPayroll(params: CreatePayrollParams)
2. getPayrollById()
3. deletePayrollById()
4. savePayroll()

5. Compute


6. Compensation

- WorkerPayInfo
- WorkerPayInfoOverride
- Compensation
- Addition
- Deduction
- enum:AdditionStatus
- enum:AdditionType
- enum:DeductionStatus
- enum:DeductionType
- enum:WorkerPayInfoType

- HCMWorkerPayInfoService

1. createWorkerPayInfo(params: WorkerPayInfoParams)
2. getWorkerPayInfo(worker: Worker)
3. deleteWorkerPayInfo(worker: Worker)
4. saveWorkerPayInfo(payInfo: WorkerPayInfo)


- HCMCompensationService

1. createCompensation(params: CompensationParams)
2. getCompensationById(compensationId: number)
3. deleteCompensationById(compensationId: number)
4. saveCompensation(compensation: Compensation)
5. getGrossValue(compensation: Compensation)
6. getAddedValue(compensation: Compensation)
7. getDeductedValue(compensation: Compensation)
8. getValue(compensation: Compensation)
9. getAdditions(compensation: Compensation)
10. getDeductions(compensation: Compensation)
11. changeStatus(compensation: Compensation, status: CompensationStatus)


- HCMAdditionService

1. createAddition(name: string, value: number)
2. getAdditionById(additionId: number)
3. deleteAdditionById(additionId: number)
4. saveAddition(addition: Addition)
5. changeValue(newValue: number)
6. changeName(newName: string)
7. assignAdditionToWorker(worker: Worker)
8. changeType(type: AdditionType)
9. changeScope(scope: AdditionScope)
10. changeStatus(status: AdditionStatus)
11. setEphemeral(state: boolean)
12. changeEffectiveDate(date: string)
13. assignAdditionToWorker(worker: Worker)


- HCMDeductionService

1. createDeduction(params: DeductionParams)
2. getDeductionById(deductionId: number)
3. deleteDeductionById(deductionId: number)
4. saveDeduction(deduction: Deduction)

6. Organization

- Organization
- PendingJoinRequest
- enum:OrganizationStatus
- enum:OrganizationIndustry
- enum:PendingJoinRequestInvitationType
- enum:PendingJoinRequestStatus

- HCMOrganizationService

TODO: Every organization should have a configuration that enables leader to change and modify certain conditions within the organization.

1. createOrg(name: string, industry: OrganizationIndustry, overrideIndustry?: string)
2. getOrgById(organizationId: number)
3. deleteOrgById(organizationId: number)
4. saveOrg()
5. changeOrgName(name: string)
6. changeOrgIndustry(industry: OrganizationIndustry)
7. changeOrgStatus(status: OrganizationStatus)
8. deleteWorkerFromOrgById(workerId: number)
9. addWorkerToOrgById(workerId: number)
10. getOrgCreator()
11. isActive()
12. isInactive()
13. isSuspended()
14. isDissolved()

- #HCMPendingJoinRequestService(Entity = unknown)

1. async sendRequest(recepientId: number)
2. async cancelRequest(recepientId: number)
3. async getPendingRequests()
4. async acceptPendingRequest(requestId: number)
5. async declinePendingRequest(requestId: number)

7. Client