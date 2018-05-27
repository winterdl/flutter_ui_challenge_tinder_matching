final demoMatches = [
  new Profile(
      firstName: 'First',
      lastName: 'About',
      school: 'UC of Wherever',
      aboutPerson: 'Empty',
      photoUrls: [
        'https://www.amtrak.com/content/dam/projects/dotcom/english/public/images/TextwithImage-Horizontal/GettyImages-482143863_comp.jpg/_jcr_content/renditions/cq5dam.web.506.380.jpeg',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRY_vBpvRv27IHyFWnmn4GZ8MZf-UPWUFqTNu0rQwZwxWg9KiAi',
        'https://imagesvc.timeincapp.com/v3/mm/image?url=http%3A%2F%2Fcdn-image.travelandleisure.com%2Fsites%2Fdefault%2Ffiles%2Fstyles%2F1600x1000%2Fpublic%2Ftravel-planning-apps-lmtravapps0817.jpg%3Fitok%3DXzXcS2nZ&w=700&q=85',
        'https://s-i.huffpost.com/gen/823975/images/o-TRAVEL-ADDICTION-facebook.jpg',
      ]),
  new Profile(
      firstName: 'Second',
      lastName: 'Card',
      school: 'Somewhere',
      aboutPerson: 'Empty',
      photoUrls: [
        'https://imagesvc.timeincapp.com/v3/mm/image?url=http%3A%2F%2Fcdn-image.travelandleisure.com%2Fsites%2Fdefault%2Ffiles%2Fstyles%2F1600x1000%2Fpublic%2Ftravel-planning-apps-lmtravapps0817.jpg%3Fitok%3DXzXcS2nZ&w=700&q=85',
        'https://s-i.huffpost.com/gen/823975/images/o-TRAVEL-ADDICTION-facebook.jpg',
        'https://www.amtrak.com/content/dam/projects/dotcom/english/public/images/TextwithImage-Horizontal/GettyImages-482143863_comp.jpg/_jcr_content/renditions/cq5dam.web.506.380.jpeg',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRY_vBpvRv27IHyFWnmn4GZ8MZf-UPWUFqTNu0rQwZwxWg9KiAi',
      ]),
  new Profile(
      firstName: 'Third',
      lastName: 'Card',
      school: 'Nowhere',
      aboutPerson: 'Empty',
      photoUrls: [
        'https://s-i.huffpost.com/gen/823975/images/o-TRAVEL-ADDICTION-facebook.jpg',
        'https://imagesvc.timeincapp.com/v3/mm/image?url=http%3A%2F%2Fcdn-image.travelandleisure.com%2Fsites%2Fdefault%2Ffiles%2Fstyles%2F1600x1000%2Fpublic%2Ftravel-planning-apps-lmtravapps0817.jpg%3Fitok%3DXzXcS2nZ&w=700&q=85',
        'https://www.amtrak.com/content/dam/projects/dotcom/english/public/images/TextwithImage-Horizontal/GettyImages-482143863_comp.jpg/_jcr_content/renditions/cq5dam.web.506.380.jpeg',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRY_vBpvRv27IHyFWnmn4GZ8MZf-UPWUFqTNu0rQwZwxWg9KiAi',
      ]),
];

class Profile {
  final List<String> photoUrls;
  final String firstName;
  final String lastName;
  final String school;
  final String aboutPerson;

  Profile({
    this.photoUrls,
    this.firstName,
    this.lastName,
    this.school,
    this.aboutPerson,
  });
}
