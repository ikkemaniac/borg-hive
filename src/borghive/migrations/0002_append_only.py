# Generated by Django 3.0.6 on 2020-05-14 18:07

from django.db import migrations, models
import django.db.models.deletion
import ldapdb.models.fields
import rules.contrib.models

def create_default_location(apps, schema_editor):
    RepositoryLocation = apps.get_model('borghive', 'RepositoryLocation')
    RepositoryLocation.objects.get_or_create(name='localhost')

class Migration(migrations.Migration):

    dependencies = [
        ('borghive', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='RepositoryLocation',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('created', models.DateTimeField(auto_now_add=True)),
                ('name', models.CharField(max_length=255, unique=True)),
            ],
            options={
                'abstract': False,
            },
            bases=(rules.contrib.models.RulesModelMixin, models.Model),
        ),
        migrations.RunPython(create_default_location),
        migrations.AddField(
            model_name='repository',
            name='append_only_keys',
            field=models.ManyToManyField(related_name='append_only_keys', to='borghive.SSHPublicKey'),
        ),
        migrations.AlterField(
            model_name='repository',
            name='ssh_keys',
            field=models.ManyToManyField(related_name='ssh_keys', to='borghive.SSHPublicKey'),
        ),
        migrations.AlterField(
            model_name='repositoryuser',
            name='group',
            field=models.IntegerField(default=1000),
        ),
        migrations.AddField(
            model_name='repository',
            name='location',
            field=models.ForeignKey(default=1, on_delete=django.db.models.deletion.CASCADE, to='borghive.RepositoryLocation'),
            preserve_default=False,
        ),
    ]