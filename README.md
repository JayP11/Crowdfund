Technical Spec
ProjectFactory
ProjectFactory should be able to create new projects.
It should emit an event on successful creation of project.
Multiple projects can be registered and each of them can accept ETH i.e. are active concurrently.
Project
The goal of Project is to raise funding.
Each project has the creator, the amount of ETH it needs to raise and corresponding NFTs to reward the contributors.
The goal amount that needs to be raised can not be changed after creation.
The goal amount of project should be more than 0.01 ETH.
Project contributions
Anyone can contribute(including creator) to the project as long as it is active.
Project is considered active if it's less than 30 days of it's creation or it is not canceled by the creator of the project.
Minimum amount one needs to be contributed is 0.01 ETH.
If the project has already raised desired amount, no can can contribute further.
The user receives 1 badge per 1 ETH contributed.
If the user has contributed 0.5 ETH, he won't receive any badge. But if he again contributes 1.2 ETH, then total contribution of ETH exceeded 1 ETH and hence 1 badge is awarded.
The contributor can be anyone. If it is contract account, it should be aware of NFT standards and should implement IERC721Receiver interface.
Force-fed ether are not considered towards contribution and should not be worry about.
NFT badge
The NFT badge is minted and awarded to the user.
User can send the NFT badge to other user at any time, even after the completion, cancellation or failure of project.
Each project has it's separate NFT badges.
Canceling the project
Only creator of the project can cancel the project if conditions listed below are satisfied.
Project is active i.e it hasn't reached desired goal and time is less than 30 days after the creation of the project.
Refund the contribution
Any contributor including creator(if he has contributed) can claim the contribution if following conditions are satisfied.
Project has not reached the goal and 30 days since it's creation are passed.
He has contributed to the project.
Project contract sends the full amount contributed by the contributor. There can't be partial withdrawals.
Withdraw the contribution
Only Creator can withdraw funds from the Project contract if following conditions are satisfied:
Project has raised the amount desired.
The amount to withdraw is less than contributions made to the Project.
Creator can withdraw partial amount also.
Project contract sends the funds to creator.
