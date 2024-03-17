# Movie Streaming Database

## Introduction
The DMDD Streaming Platform project outlines a comprehensive system designed to manage and deliver streaming content to users. It encompasses various components including business rules, views, and security roles, ensuring a robust and user-friendly platform. This document serves as a guide to understanding the project's scope, functionalities, and the architecture of the database system that supports these operations.

## Business Rules
- Customers must enter all required details when creating a new account.
- Customer accounts are accessed through unique credentials.
- A correct account number is required to view customer account details.
- Each customer's email ID must be unique.
- A customer can have multiple accounts, but each must have a unique email ID.
- Users can delete their accounts and cancel subscriptions.
- Users can access multiple screens depending on their plan.
- Email IDs can be changed but must remain unique.
- Users should only access content available in their location.
- Each user account can purchase only one plan at a time.
- Users can download movies, available across all devices for the same user account after logging in.
- Watchlists and favorites are private to each user, with movies being addable to both.
- Viewing history is maintained for each username.

## Views
- **Content View:** Information on available movies including title, genre, release year, director, cast, description, and rating.
- **User View:** Stores user information including username, password, email, and payment information, along with subscription level, viewing history, and preferences.
- **Subscription View:** Information about subscription plans including pricing, features, and restrictions.
- **Payment View:** Details on payments including method, date, amount, and status, as well as refunds and cancellations.
- **Analytics View:** Insights into platform usage and performance, including user numbers, views, popular content, and engagement.
- **Recommendation View:** Personalized recommendations based on viewing history, preferences, and behavior.
- **Regulatory View:** Stores regulatory requirements for content classification and labeling.

## Security Roles
- **Administrator:** Full access to all data and functionality, responsible for managing accounts, access controls, and backups.
- **Content Manager:** Manages content addition, modification, deletion, and user permissions for content access.
- **Billing Manager:** Handles all billing information, including subscriptions, payments, refunds, and user billing information management.
- **Customer:** Can view and edit personal information, history, watchlist, subscription, payment info, and watch movies.
- **Data Analyst:** Accesses user and platform data for analysis and generating insights based on user behavior and preferences.

## Getting Started
To get started with the DMDD Streaming Platform project, ensure you have the necessary database management tools and understand the outlined business rules and security roles. Familiarize yourself with the different views that structure the database, and how they interact with each other to provide a seamless user experience.

## Conclusion
The DMDD Streaming Platform project is designed to deliver a comprehensive streaming service that caters to the diverse needs of its users while maintaining high standards of data security and user privacy. By adhering to the outlined business rules and leveraging the structured views and security roles, the platform ensures a robust and scalable solution for streaming content delivery.
